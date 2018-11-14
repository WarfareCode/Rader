__author__ = 'caocongcong'

from primary_signal.const_value import constValue
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
from util.fluter import fluter_design
from util.Tool import show_Data

# 进行信号的采样

class AD:
    def __init__(self, primary_signal, simu_time, frame_time):
        '''
        进行信号的AD采样，首先对原始信号的进行划分，按照帧长划分成子段
        对每个子段进行下变频，然后进行滤波以及重采样
        对每个子信道进行下变频，滤波进行重采样
        汇总每个子带计算的参数进行合并
        :param primary_signal 原始的信号
        :param simu_time 整体系统的仿真时间
        :frame_time 一帧的时间
        '''
        # 原始信号
        # 恢复成不是正信号
        self.primary_signal = primary_signal
        # 系统整体的仿真时间
        self.simu_time = simu_time
        # 帧的时长
        self.frame_time = frame_time
        # 计算的帧数
        self.frame_number = self.simu_time / self.frame_time
        # 每帧的数目
        self.frame_sample_number = int (self.frame_time * constValue.system_freq)
        # 第一次变频的基带频率
        self.frist_base = [200, 600, 1000]
        # 第二次变频的基带频率
        self.seconde_base = [-170, -110, -50, 10, 70, 130, 190]
        # 保存最终的信号
        self.final_primary_data = []





    def first_complex_ad(self, tmp_index, tmp_signal):
        '''
        第一次进行复采样
        :param conbersion_fs: 变频的频率
        :param sample_fs: 原始的采样频率
        :param input_data:
        :return:self.first_complex_signal
        '''
        con_signal_I = self.down_conversion("Cos", self.frist_base[tmp_index], constValue.system_freq, tmp_signal)
        con_signal_I = self.FIR_filter("200M", con_signal_I)
        con_signal_Q = self.down_conversion("Sin", self.frist_base[tmp_index], constValue.system_freq, tmp_signal)
        con_signal_Q = self.FIR_filter("200M", con_signal_Q)
        # 进行重采样
        con_signal_I = signal.resample(con_signal_I,
                                       int(len(con_signal_I) * constValue.first_sample_fs / constValue.system_freq))
        con_signal_Q = signal.resample(con_signal_Q,
                                       int(len(con_signal_Q) * constValue.first_sample_fs / constValue.system_freq))
        print("第一轮采样的数据")
        print("I路的长度", len(con_signal_I))
        print("Q路的长度", len(con_signal_Q))
        self.first_complex_signal = np.array(con_signal_I - con_signal_Q * 1j)


    def second_complex_ad(self, index):
        '''
        :param index 此次下变频的基频
        进行第二次的信道化采样
        :return:
        '''
        con_siganl = self.down_conversion_complex(self.seconde_base[index], constValue.first_sample_fs, self.first_complex_signal)
        # con_signal_I = self.down_conversion("Cos", self.seconde_base[index], constValue.first_sample_fs, np.real(self.first_complex_signal))
        # con_signal_Q = self.down_conversion("Sin", self.seconde_base[index], constValue.first_sample_fs, np.imag(self.first_complex_signal))
        con_signal_I = np.real(con_siganl)
        con_signal_Q = np.imag(con_siganl)
        con_signal_I = self.FIR_filter("30M", con_signal_I)
        con_signal_Q = self.FIR_filter("30M", con_signal_Q)
        # 重采样
        con_signal_I = signal.resample(con_signal_I, int(len(con_signal_I)*constValue.second_sample_fs/ constValue.first_sample_fs))
        con_signal_Q = signal.resample(con_signal_Q, int(len(con_signal_Q)*constValue.second_sample_fs/ constValue.first_sample_fs))
        print("第二轮采样的数据")
        print("I路的长度", len(con_signal_I))
        print("Q路的长度", len(con_signal_Q))
        self.second_complex_signal_current = np.array(con_signal_I - con_signal_Q * 1j)


    def split_signal(self):
        '''
        进行信号初步划分，将仿真时间内的信号划分成几个子段，每个子段的长度为帧的frame_sample_number
        :return: 更新split_signal_data
        '''
        # 保存切分后的数据
        self.split_signal_data = []
        # 当前划分到的数据下标
        current_index = 0
        # 当没有划分完毕的时候
        while current_index < len(self.primary_signal):
            # 说明取到了最后一行，此时直接全部加入
            if current_index + self.frame_sample_number > len(self.primary_signal):
                # 全部加入
                tmp = self.primary_signal[current_index:]
                self.split_signal_data.append(tmp)
                # 退出循环
                break

            # 每次截取采样长度的点
            tmp = self.primary_signal[current_index: current_index+self.frame_sample_number]
            # 当前位置递增
            current_index += self.frame_sample_number
            # 加到最后
            self.split_signal_data.append(tmp)
        print("最后划分的个数"+ str(len(self.split_signal_data)))


    def down_conversion_complex(self, conbersion_fs, sample_fs, input_data):
        '''
        复信号的采样
        :param Mode: 是I路还是Q路，决定乘以sin还是cos
        :param conbersion_fs: 转到的频率
        :param sample_fs: 采样频率
        :param input_data :输入数据
        :return: 变频之后的数据
        '''
        t = np.linspace(0, len(input_data), len(input_data))
        changed_signal_sin = np.sin(2 * np.pi * t / (sample_fs / conbersion_fs))
        changed_signal_cos = np.cos(2*np.pi * t/(sample_fs/conbersion_fs))
        changed_signal = np.array(changed_signal_cos - changed_signal_sin*1j)
        changed_signal *= input_data
        return changed_signal

    def down_conversion(self, Mode, conbersion_fs, sample_fs, input_data):
        '''
        进行下变频，转化到自己所需要的频率
        :param Mode: 是I路还是Q路，决定乘以sin还是cos
        :param conbersion_fs: 转到的频率
        :param sample_fs: 采样频率
        :param input_data :输入数据
        :return: 变频之后的数据
        '''
        if Mode == "Sin":
            # 产生等长sin的信号
            t = np.linspace(0, len(input_data), len(input_data))
            changed_signal = np.sin(2*np.pi*t/(sample_fs/conbersion_fs))
            # 对原始信号进行变化
            changed_signal *= input_data
        else:
            # 产生等长cos的信号
            t = np.linspace(0, len(input_data), len(input_data))
            changed_signal = np.cos(2*np.pi*t/(sample_fs/conbersion_fs))
            # 对原始信号进行变化
            changed_signal *= input_data

        return changed_signal

    def FIR_filter(self, Mode, input_data):
        '''
        低通滤波器，进行滤波处理，实际只有400M和60M两种选择
        :param Mode: 只有两种选择，为400M和60M
        :return:
        '''
        if Mode == "200M":
            # 400M的带宽，使用预先写入的数据建立滤波器
            b = fluter_design(constValue.first_fluter_length, constValue.first_fluter_base, constValue.first_fluter_pass, constValue.system_freq)
            # 将滤波的值返回回来
            # fig = plt.figure()
            # ax1 = fig.add_subplot(2,1,1)
            # ax1.plot(np.abs(np.fft.fft(input_data)))
            after_filter = signal.filtfilt(b, 1, input_data)
            # ax2 = fig.add_subplot(2,1,2)
            # ax2.plot(np.abs(np.fft.fft(after_filter)))
            # plt.show(fig)
            return after_filter
        else:
            # 60M的带宽
            # 返回滤波的值
            b = fluter_design(constValue.second_fluter_length, constValue.second_fluter_base, constValue.second_fluter_pass, constValue.first_sample_fs)
            return signal.filtfilt(b, 1, input_data)
    def AD_data(self):
        # 读数据进行采样的主流程
        # 首先进行数据划分
        self.split_signal()
        # 计数器进行观察
        order = 0
        # 对划分的数据进行进行处理
        frist_index = 0
        while frist_index < len(self.split_signal_data):
            # 首先进行变频,分别获得I路和Q路的数据
            self.first_complex_ad(frist_index% len(self.frist_base), self.split_signal_data[frist_index])
            frist_index += 1
            # 进行第二次变频
            second_tmp_index = 0
            while second_tmp_index < len(self.seconde_base):
                self.second_complex_ad(second_tmp_index % len(self.seconde_base))
                self.cul_param(self.second_complex_signal_current, frist_index)
                second_tmp_index += 1



    # 进行参数测量
    def cul_param(self, data, frist_index):
        pass
