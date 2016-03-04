#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2015年7月21日

@author: zhang.xiuhai
'''

from  robot.api import logger
import os
import re
import subprocess
import string
from sys import stderr

class CAppiumLibrary(object):
    '''
    classdocs
    '''


    def __init__(self):
        '''
        Constructor
        '''
    
    def get_local_address(self):    
        u'''获取本地的地址.例
        
        '''
        tmpconfig = os.popen('ipconfig').read()
        ip = re.search(r'192.168.*.*', tmpconfig)
        return ip.group(0)
    
    def launch_appium(self, ip, tport, mode):
        u'''根据ip，port，mode启动本地appium，例
            
        '''
        launchCMD = "appium.cmd -a " + ip + " -p " + tport + " " + "--" + mode
        child = subprocess.Popen(launchCMD, shell=True)
        return child.pid

    def stop_appium(self, pid):
        u'''停止测试工具Appium
        '''
        stopAppiumCMD = "tskill " +str(pid)
        os.system(stopAppiumCMD)
        
    def get_port_pid(self, port):   
        u'''根据参数中的端口号查找对应使用该端口号的进程ID，
                        并返回该进程的PID号。
        '''
        getPidCMD = "netstat -ano | findstr " + port
        appiumPidStr = os.popen(getPidCMD).read()

        if appiumPidStr:
            appiumG = appiumPidStr.split(' ')
            return appiumG[-1]
            logger.console("process about port " + port +" is "+appiumG[-1]+" .", True, 'stdout')
        else:
            logger.console("No process about port " + port +"!", True, 'stdout')
        
    def set_androidlog_status(self, flag=False, mode=True):
        u'''设置android日志开关
        '''
        srchAdbCMD = "tasklist | findstr adb"
        logPid = self.get_CMD_pid('adb.exe')
        
        if mode == True:
            logCMD = "adb shell logcat -v time >logcat_" + flag + ".log &1"
            subprocess.Popen(logCMD, shell=True)
        elif mode == False:
            for i in logPid:
                logoffCMD = "tskill " + i
                child = subprocess.Popen(logoffCMD, shell=True)
                child.wait()
        else:
            return -1
        
        logger.debug("Debug on.", html=True)
        
    def grap_androidLog_afterOper(self, flag, path):  
        u'''获取操作后日志
        '''
        os.system("adb logcat -v time -d > "+path+"log_" + flag + ".log &1")
    
    
    def get_CMD_pid(self, tcmd):
        srchAdbCMD = "tasklist | findstr adb.exe"
        rStr = os.popen(srchAdbCMD).read()
        rg = rStr.split(' ')
        pidList = []
        num = 0
        for i in rg:
            if re.search(tcmd, i):
                num = num + 1
            elif re.match(r'\d{5}|\d{4}', i):
                pidList.append(i)
            else:
                pass
            
        if num <= 1 :
            logger.console("The process about "+ tcmd +" is not exist.", True)
        else:
            return pidList[1:num]
        
if __name__ == '__main__':
    tmpObject = CAppiumLibrary()
#     tmpObject.set_androidlog_status('test1', True)
#     tpidList =  tmpObject.get_CMD_pid('adb.exe')
#     tmpObject.set_androidlog_status('test729343434322', True)
#     tmpObject.set_androidlog_status(False, False)
    
#     tmpPid = tmpObject.get_port_pid('4723')
    tmpIp = tmpObject.get_local_address()
    tmpPid = tmpObject.launch_appium(tmpIp, '4723', "no-reset")
    print tmpPid
    
    if tmpPid:
#         tmpObject.stop_appium(tmpPid)
        print "stop appium."
    else:
        pass
