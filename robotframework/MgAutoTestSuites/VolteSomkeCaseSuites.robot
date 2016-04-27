*** Settings ***
Suite Setup
Suite Teardown
Test Teardown     Close All Applications
Library           AppiumLibrary
Library           CustomLibrary
Resource          test_mg_ecmapp_resource.robot

*** Test Cases ***
【N】用户登录解锁:【入口】通知栏
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM未开启“记住口令”和“免口令登录”开关"
    ...
    ...    操作步骤：
    ...    "1. 开机，检查通知栏
    ...    2. 点击通知栏上的ECM提示信息
    ...    3. 点击通知栏上的“登录”按钮"
    ...
    ...    预期结果：
    ...    "1. 通知栏提示“密码卡未登录：无法使用加密通讯功能”
    ...    2. 跳转到ECM登录界面，界面显示正常，符合设计
    ...    3. 跳转到ECM登录界面，界面显示正常，符合设计"
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    15s    failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    60s    check failed!
    Page Should Contain Text    关闭    DEBUG
    Kill Adb Process    ecm
    sleep    20s
    Cswipe    250    0    250    500
    Wait Until Page Contains    密码卡未登录    10s    failed!
    Page Should Contain Text    无法使用加密通讯功能    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/tvtryagain
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    30s    sign in failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Sleep    10s
    close application
    [Teardown]    Kill Adb Process    ecm

【N】用户登录解锁:【入口】应用程序列表
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM未开启“记住口令”和“免口令登录”开关" ；
    ...
    ...    操作步骤：
    ...    "1. 开机，从应用程序列表界面启动ECM；"
    ...
    ...    预期结果：
    ...    "1. 跳转到ECM登录界面，界面显示正常，符合设计；"
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.huawei.android.launcher
    ...    appActivity=.Launcher
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    30s    check failed!    #登录提示
    Go Back
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG    #密码输入框
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/loginBT    DEBUG    #登录按钮
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/rememberLayout    DEBUG    #记住口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/forgetPWD    DEBUG    #忘记密码
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/chaIV    DEBUG    #停止登录
    sleep    20s    #待系统稳定
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】用户登录解锁:【暂不登录】跳过或继续登录
    [Documentation]    预置条件:
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM未开启“记住口令”和“免口令登录”开关
    ...    3. 终端处于ECM登录界面"
    ...
    ...    操作步骤：
    ...    "1. 点击右上角的“暂不登录”按钮或系统的“返回”按钮
    ...    2. 点击“跳过”按钮
    ...    3. 点击“继续”按钮"
    ...
    ...    预期结果：
    ...    "1. 弹出“跳过登录将不能使用加密通讯功能是否跳过”提示框
    ...    2. ECM登录界面消失，返回到桌面
    ...    3. 继续停留在ECM登录界面"
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    15s    failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    60s    check failed!
    Page Should Contain Text    关闭    DEBUG
    Close Application
    Kill Adb Process    ecm
    sleep    20s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    30s    sign in failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/chaIV    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/chaIV
    Wait Until Page Contains    跳过登录将不能使用加密通讯功能    30s    operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/alertEnter    DEBUG    #跳过按钮
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/alertCancel    DEBUG    #继续按钮
    Sleep    10s
    ${reval}=    Run Keyword And Return Status    Click Element    id=com.cetcs.ecmapplication:id/alertCancel    #无法点击继续按钮？
    ${reval1}=    Run Keyword And Return Status    Evaluate    os.system('adb shell input tap 846 1074')    os    #继续按钮元素标签所在位置
    log    ${reval}
    log    ${reval1}
    Wait Until Page Contains    请输入密码卡口令    30s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/chaIV
    Wait Until Page Contains    跳过登录将不能使用加密通讯功能    30s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Page Should Not Contain Element    id=com.cetcs.ecmapplication:id/loginHint    DEBUG    #退出登录界面
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】用户登录解锁:【口令场景】正确的口令
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡，TF密码卡的口令为初始口令
    ...    2. ECM未开启“记住口令”和“免口令登录”开关
    ...    3. 终端处于ECM登录界面"
    ...
    ...    操作步骤：
    ...    "1. 输入正确口令，点击“登录”按钮"
    ...
    ...    预期结果：
    ...    "1. 登录成功，跳转到ECM主界面，界面显示正常，符合设计"
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/guanyuIV    DEBUG
    Page Should Contain Text    修改口令    DEBUG
    Page Should Contain Text    销毁密码卡    DEBUG
    Page Should Contain Text    安全参数    DEBUG
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】用户登录解锁:【口令场景】错误的口令(密码长度实现已变更）
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡，TF密码卡的口令为初始口令，且口令的当前允许错误输入次数为6次
    ...    2. ECM未开启“记住口令”和“免口令登录”开关
    ...    3. 终端处于ECM登录界面"
    ...
    ...    操作步骤：
    ...    "1. 不输入口令，点击“登录”按钮
    ...    2. 输入1位口令，点击“登录”按钮
    ...    3. 输入5位口令，点击“登录”按钮
    ...    4. 输入6位错误口令，点击“登录”按钮
    ...    5. 输入16位错误口令（包含数字、字母和字符），点击“登录”按钮
    ...    6. 输入17位错误口令
    ...    7. 输入任意口令，点击“清空”按钮"
    ...
    ...    预期结果：
    ...    "1. 登录失败，停留在当前界面，弹出“请输入密码卡口令”提示
    ...    2. 登录失败，停留在当前界面，弹出“口令长度错误！剩余5次输入”提示，口令自动被清空
    ...    3. 登录失败，停留在当前界面，弹出“口令长度错误！剩余4次输入”提示，口令自动被清空
    ...    4. 登录失败，停留在当前界面，弹出“口令长度错误！剩余3次输入”提示，口令自动被清空
    ...    5. 登录失败，停留在当前界面，弹出“口令长度错误！剩余2次输入”提示，口令自动被清空
    ...    6. 只能输入16位口令，16位以后的输入不被允许和显示，仍停留在当前界面
    ...    7. 输入内容被清空，仍停留在当前界面
    ...    "
    [Tags]    用户登录解锁(#634)    change
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Click Element    id=com.cetcs.ecmapplication:id/loginBT    #不输入密码是点击登录按钮
    Wait Until Page Does Not Contain Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    1    #1位passsword
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Does Not Contain Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    2345    #5位password
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Does Not Contain Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    7    #6位错误password
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Text    再输错5次密码卡将被锁定    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error123456    #16位错误password
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Text    再输错4次密码卡将被锁定    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error1234567    #输入17位password
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    30s    check failed!
    Page Should Contain Text    再输错3次密码卡将被锁定    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error123456
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/pwdClearIV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/pwdClearIV
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/errorTV    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    15s    failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Page Should Contain Text    关闭    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/guanyuIV    DEBUG
    sleep    30S
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】用户登录解锁:【自动登录】口令一致
    [Documentation]    预置条件:
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM已开启“记住口令”或“免口令登录”开关
    ...    3. ECM记住的口令与当前TF密码卡的口令一致"
    ...
    ...    操作步骤：
    ...    "1. 开机，启动ECM"
    ...
    ...    预期结果：
    ...    "1. 登录成功，跳转到ECM主界面，界面显示正常，符合设计"
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    #预置条件
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    安全提示    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_confirm2    30s    check failed!
    #Click Element    name=去设置    #点击去设置，id和name都无法识别，需要直接tap屏幕对应位置
    ${pram1}    Evaluate    os.system('adb shell input tap 790 1100')    os    #“去设置”元素标签所在位置
    log    ${pram1}
    Wait Until Page Contains    解锁方式选择    30s    check failed!    #锁屏密码设置
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    30s    check failed!    #回到ecm登录界面
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    60s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Close Application
    Kill Adb Process    ecm
    Sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains    ${TELE_NUMBER}    30s    check failed!
    Page Should Contain Text    加密功能已启用    DEBUG
    #初始化环境-teardown
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    #免口令登录设置按钮id和name无法识别
    #${pram1}    Evaluate    os.system('adb shell input tap 957 390')    os    #“去设置”元素标签所在位置
    #log    ${pram1}
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Click Element    name=关闭
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    15s    relogin failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    600    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：修改口令流程
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤： "1. 点击修改口令按钮；
    ...    2. 输入旧口令，点击确定按钮；
    ...    3. 输入新口令，点击下一步按钮；
    ...    4. 再次输入新口令，点击确定按钮；
    ...    5. 点击完成按钮；
    ...    6. 重启手机，点击启动密码卡管家，进入登录界面，输入新口令后点击登录按钮；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 成功输入后正常跳转到请输入新口令界面，界面显示正常；
    ...    3. 成功输入后正常跳转到请再次输入新口令界面，界面显示正常；
    ...    4. 密码修改成功，进入修改口令成功界面；
    ...    5. 进入加密功能已启用界面；
    ...    6. 使用新口令能成功登录；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    #预置条件
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Text    修改口令成功    DEBUG
    Page Should Contain Text    请牢记您设置的新口令    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Close Application
    Kill Adb Process    ecm
    sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV    #确定按钮
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/simpleTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/simpleTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Text    修改口令成功    DEBUG
    Page Should Contain Text    请牢记您设置的新口令    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：两次输入的新口令不一致
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    "1. 点击修改口令按钮；
    ...    2. 输入正确的旧口令，点击确定；
    ...    3. 输入新口令，点击下一步按钮；
    ...    4. 输入与第一次不一致的新口令，点击确定按钮；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 成功输入后正常跳转到请输入新口令界面，界面显示正常；
    ...    3. 成功输入后正常跳转到请再次输入新口令界面，界面显示正常；
    ...    4. 清空输入，提示用户口令不匹配，请重新输入；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    123457    #两次密码不一致
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    123458    #两次密码不一致
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    15s    operation failed!
    Page Should Not Contain Element    id=com.cetcs.ecmapplication:id/pwdClearIV    DEBUG
    Page Should Contain Text    请再次输入新口令    DEBUG
    Page Should Contain Text    口令不匹配，请重新输入    DEBUG
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：新口令的输入验证(密码长度实现已变更)
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    "1. 点击修改口令按钮；
    ...    2. 输入正确的旧口令，点击确定；
    ...    3. 输入小于6位的新口令，点击下一步；
    ...    4. 输入大于16位的新口令，点击下一步；
    ...    5. 不输入新口令，点击下一步；
    ...    6. 输入空格，点击下一步；
    ...    7. 输入纯字母，纯字符，纯数字，字母与数字组合，字母与字符组合，字符与数字组合，数字、字母和字符组合，点击下一步；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 成功输入后正常跳转到请输入新口令界面，界面显示正常；
    ...    3. 清空输入，提示用户密码长度在6-16位之间；
    ...    4. 提示用户密码长度在6-16位之间，超过16位的密码无法成功输入；
    ...    5. 提示用户输入新口令；
    ...    6. 成功跳转到再次输入新口令确认界面；
    ...    7. 成功跳转到再次输入新口令确认界面；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG    #输入旧密码框
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/nextStepLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/simpleTV    DEBUG    #确定按钮
    Page Should Contain Text    忘记口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    12345    #小于六位的新口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV    #点击下一步
    Wait Until Page Does Not Contain Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    678987654321    #大于16位
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Page Should Not Contain Element    id=com.cetcs.ecmapplication:id/errorInfo    DEBUG
    Page Should Contain Text    请再次输入新口令    DEBUG
    Go Back
    Go Back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV    #不输入口令
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Page Should Not Contain Text    请再次输入新口令    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    volteecm    #全字母
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Go Back
    Go Back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    volteecm123    #字母与数字组合
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    go back
    go back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：新口令与旧口令一致（待完善）
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    1. 点击修改口令按钮；
    ...    2. 输入旧口令，点击确定按钮；
    ...    3. 输入新口令，并且新口令与旧口令一致，点击下一步按钮；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 成功输入后正常跳转到请输入新口令界面，界面显示正常；
    ...    3. 是否控制输入的新口令不能与旧口令一致？（待确认）"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    change password operation failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}    #新旧密码两次一致
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Page Should Contain Text    修改口令成功
    Page Should Contain Text    请牢记您设置的新口令
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：修改口令流程中点击手机返回键
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    "1. 点击修改口令按钮；
    ...    2. 点击手机返回键；
    ...    3. 再次进入修改口令界面，输入旧口令，点击确定；
    ...    4. 点击手机返回键；
    ...    5. 点击确定；
    ...    6. 点击取消；
    ...    7. 输入新口令点击下一步；
    ...    8. 点击手机返回键；
    ...    9. 点击确定；
    ...    10. 点击取消；
    ...    11. 输入新口令点击确定；
    ...    12. 点击手机返回键；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 正常返回到加密功能已启用界面；
    ...    3. 进入输入新口令界面；
    ...    4. 弹出是否终止修改口令提示信息；
    ...    5. 返回加密功能已启用界面；
    ...    6. 停留当前界面；
    ...    7. 进入再次确认新口令界面；
    ...    8. 弹出是否终止修改口令提示信息；
    ...    9. 返回加密功能已启用界面；
    ...    10. 停留当前界面；
    ...    11. 进入口令修改成功界面；
    ...    12. 提示是否返回加密功能主界面；点击确定返回到加密功能启用界面，点击取消，停留在当前界面；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    go back
    go back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    go back
    go back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter    #确定取消修改密码
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    go back
    Go Back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertCancel    #确定取消修改密码
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    go back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter    #确定修改密码
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    go back
    Go Back
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/alertTV    30s    check failed!
    Page Should Contain Text    是否终止修改口令？    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/alertCancel    #确定取消修改密码
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Page Should Contain Text    修改口令成功
    Page Should Contain Text    请牢记您设置的新口令
    go back
    Go Back
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：修改口令流程中点击手机home键
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    "1. 点击修改口令按钮；
    ...    2. 点击手机home键返回到手机桌面，重新点击APP图标进入应用；
    ...    3. 输入旧口令，点击确定按钮；
    ...    4. 点击手机home键返回到手机桌面，重新点击APP图标进入应用；
    ...    5. 输入新口令，点击下一步按钮；
    ...    6. 点击手机home键返回到手机桌面，重新点击APP图标进入应用；
    ...    7. 再次输入新口令，点击确定按钮；
    ...    8. 点击手机home键返回到手机桌面，重新点击APP图标进入应用；
    ...    9. 点击完成按钮；
    ...    10. 点击手机home键返回到手机桌面，重新点击APP图标进入应用；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 正确返回到输入旧口令界面；
    ...    3. 成功输入后正常跳转到请输入新口令界面，界面显示正常；
    ...    4. 正确返回到请输入新口令界面；
    ...    5. 成功输入后正常跳转到请再次输入新口令界面，界面显示正常；
    ...    6. 正确返回到再次输入新口令界面；
    ...    7. 密码修改成功，进入修改口令成功界面；
    ...    8. 正确返回到修改口令成功界面；
    ...    9. 进入加密功能已启用界面；
    ...    10. 正确返回到加密功能已启用界面；
    ...    "
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    #忘记口令?
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    #忘记口令?
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Wait Until Page Contains    修改口令成功    30s    check failed!
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    修改口令成功    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/relogoin    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/relogoin    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：修改口令后各种状态下重新登录
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；
    ...    3.修改口令已完成，当前处于修改口令成功界面；"
    ...
    ...    操作步骤：
    ...    "1. 重启手机；
    ...    2. 点击手机home键返回桌面，使用进程管理键结束进程；
    ...    3. 点击手机home键返回桌面，进入设置-》应用管理-》密码卡管家，强行停止进程；
    ...    4. 使用cmd命令行kill ECM进程；
    ...    5. 使用一键清理大师、360安全卫士第三方软件结束ECM进程；"
    ...
    ...    预期结果：
    ...    "1. 重新点击APP图标进入应用，使用新口令能成功登录；
    ...    2. ECM进程不会结束，重新点击APP图标进入应用，ECM处于已登录状态，无需输入密码；
    ...    3. ECM进程不会结束，重新点击APP图标进入应用，ECM处于已登录状态，无需输入密码；
    ...    4. 重新点击APP图标进入应用，使用新口令能成功登录；
    ...    5. ECM进程不会结束，重新点击APP图标进入应用，ECM处于已登录状态，无需输入密码；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    #预置条件
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    #忘记口令?
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}    #修改密码成功
    Sleep    10s
    #预置条件-end
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/rememberLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Press Keycode    3
    #准备进入到设置停止进程
    close application
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    1500    250    250
    sleep    10s
    Wait Until Page Contains    应用管理    30s    check failed!
    Click Element    name=应用管理
    Cswipe    250    1500    250    250
    sleep    10s
    Wait Until Page Contains    密码卡管家    30s    check failed!
    sleep    10s
    Click Element    name=密码卡管家
    Wait Until Page Contains    应用信息    30s    check failed!
    Click Element    id=com.android.settings:id/right_button
    Wait Until Page Contains    是否强行停止？    30s    check failed!
    Click Element    id=android:id/button1    #确定强制停止
    Sleep    10s
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Kill Adb Process    ecm
    Click Element    name=密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #teardown恢复环境
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/relogoin    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：修改口令后自动登录
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家已设置""记住密码""或者已设置免口令登录；
    ...    3.修改口令已完成，当前处于修改口令成功界面；"
    ...
    ...    操作步骤：
    ...    "1. 重启手机
    ...    2. 点击APP图标启动应用
    ...    3. 输入修改后的新密码，点击登录按钮
    ...    4. 重启手机
    ...    5. 点击APP图标启动应用"
    ...
    ...    预期结果：
    ...    "1. 成功重启
    ...    2. 进入ECM登录界面，未自动登录，""记住密码""开关仍为开启状态
    ...    3. 登录成功
    ...    4. 成功重启
    ...    5. ECM自动登录成功"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    #预置条件
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    安全提示    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_confirm2    30s    check failed!
    #Click Element    name=去设置    #点击去设置，id和name都无法识别，需要直接tap屏幕对应位置
    ${pram1}    Evaluate    os.system('adb shell input tap 790 1100')    os
    log    ${pram1}
    Wait Until Page Contains    解锁方式选择    30s    check failed!
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    60s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Page Should Contain Text    请输入新口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Page Should Contain Text    请再次输入新口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Text    修改口令成功    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Page Should Contain Text    请牢记您设置的新口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Sleep    10s
    #预置条件-end
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    25s
    #${prams}    Evaluate    os.system("adb shell input keyevent 26")    os
    #log    ${prams}
    ${prams1}    Evaluate    os.system("adb shell input swipe 50 250 1000 250")    os
    log    ${prams1}
    ${pram1}    Evaluate    os.system('adb shell input tap 200 1143')    os    #key1
    log    ${pram1}
    ${pram2}    Evaluate    os.system('adb shell input tap 540 1143')    os    #key2
    log    ${pram2}
    ${pram3}    Evaluate    os.system('adb shell input tap 880 1143')    os    #key3
    log    ${pram3}
    ${pram4}    Evaluate    os.system('adb shell input tap 200 1324')    os    #key4
    log    ${pram4}
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    25s
    ${prams2}    Evaluate    os.system("adb shell input swipe 50 250 1000 250")    os
    log    ${prams2}
    ${pram1}    Evaluate    os.system('adb shell input tap 200 1143')    os    #key1
    log    ${pram1}
    ${pram2}    Evaluate    os.system('adb shell input tap 540 1143')    os    #key2
    log    ${pram2}
    ${pram3}    Evaluate    os.system('adb shell input tap 880 1143')    os    #key3
    log    ${pram3}
    ${pram4}    Evaluate    os.system('adb shell input tap 200 1324')    os    #key4
    log    ${pram4}
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #关闭免口令登录
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Click Element    name=关闭
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    #恢复初始密码
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    change password operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Page Should Contain Text    修改口令成功
    Page Should Contain Text    请牢记您设置的新口令
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    Sleep    10s
    #关闭锁屏数字密码
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    650    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Run Keyword If Test Failed    close application

【N】修改密码卡口令：修改口令后使用旧口令登录
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；
    ...    3.修改口令已完成，当前处于修改口令成功界面；"
    ...
    ...    操作步骤：
    ...    "1. 重启手机；
    ...    2. 点击手机home键返回桌面，使用进程管理键结束进程；
    ...    3. 点击手机home键返回桌面，进入设置-》应用管理-》密码卡管家，强行停止进程；
    ...    4. 使用cmd命令行kill ECM进程；
    ...    5. 使用一键清理大师、360安全卫士第三方软件结束ECM进程；"
    ...
    ...    预期结果：
    ...    "1. 重新点击APP图标进入应用，使用旧口令不能成功登录；
    ...    2. 重新点击APP图标进入应用，使用旧口令不能成功登录；
    ...    3. 重新点击APP图标进入应用，使用旧口令不能成功登录；
    ...    4. 重新点击APP图标进入应用，使用旧口令不能成功登录；
    ...    5. 重新点击APP图标进入应用，使用旧口令不能成功登录；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    #忘记口令?
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/remberYourNewPin    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/relogoin    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}    #修改密码成功
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/rememberLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    30s    sign in failed!
    Wait Until Page Contains    再输错5次密码卡将被锁定    30s    sign in failed!
    Press Keycode    3
    #准备进入到设置停止进程
    close application
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    1500    250    250
    Wait Until Page Contains    应用管理    30    check failed!
    Click Element    name=应用管理
    Cswipe    250    1500    250    250
    Wait Until Page Contains    密码卡管家    30    check failed!
    sleep    5s
    Click Element    name=密码卡管家
    Wait Until Page Contains    应用信息    30    check failed!
    Click Element    id=com.android.settings:id/right_button
    Wait Until Page Contains    是否强行停止？    30    check failed!
    Click Element    id=android:id/button1    #确定强制停止
    Sleep    10s
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/rememberLayout    30s    check failed!
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    30s    sign in failed!
    Wait Until Page Contains    再输错4次密码卡将被锁定    30s    sign in failed!
    Kill Adb Process    ecm
    Press Keycode    3
    Wait Until Page Contains    密码卡管家    30    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    再输错3次密码卡将被锁定    30s    sign in failed!
    Sleep    10s
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}    #修改密码成功
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/changeSuccess    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/relogoin    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application
    [Teardown]    Kill Adb Process    ecm

【N】修改密码卡口令：忘记口令（待完善）
    [Documentation]    预置条件：
    ...    1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...
    ...    操作步骤：
    ...    "1. 点击修改密码；
    ...    2. 点击忘记口令；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 进入重置密码卡口令界面；"
    [Tags]    修改密码卡口令(#636)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Page Should Contain Text    请输入旧口令    DEBUG
    Page Should Contain Text    忘记口令？    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/buttonTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/resetTitle    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/resetInfo    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/reset    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/ellipseButton    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/pinButton    30s    check failed!
    Page Should Contain Text    请输入有效的PIN码后    DEBUG
    Page Should Contain Text    重置密码卡口令    DEBUG
    Page Should Contain Text    拨打10086获取PIN码    DEBUG
    Page Should Contain Text    输入PIN码    DEBUG
    Sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：开启免口令登录：终端屏幕解锁密码功能未开启
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能未开启；
    ...    3. ECM应用中，TF密码卡免口令登录功能关闭；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 点击免口令登录-》设置按钮；
    ...    3. 选择开启选项；
    ...    4. 开启终端屏幕解锁密码功能，返回到设置界面，选择开启选项； 点击确定；
    ...    5. 重启手机，重启成功后点击APP图标启动应用；"
    ...
    ...    预期结果：
    ...    "1. 成功进入安全设置界面；
    ...    2. 弹出长期存储口令设置界面；
    ...    3. 系统弹出请打开屏幕解锁密码功能的提示信息，点击确定跳转到终端手机设置解锁方式界面；点击取消停留在当前界面；
    ...    4. 成功选择开启选项；
    ...    5. 自动登录进入加密功能已启用界面；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    30s    check failed!
    Page Should Contain Text    免口令登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    failed!
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    关闭
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    log    ${opened}
    sleep    10s
    Run Keyword If    ${opened}    Click Element    name=开启
    ...    ELSE    log    已开启
    sleep    10s
    Click Element    name=确定
    Wait Until Page Contains    安全提示    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_confirm2    30s    check failed!
    #Click Element    name=去设置    #点击去设置，id和name都无法识别，需要直接tap屏幕对应位置
    ${pram1}    Evaluate    os.system('adb shell input tap 790 1100')    os    #“去设置”元素标签所在位置
    log    ${pram1}
    Wait Until Page Contains    解锁方式选择    30s    check failed!    #锁屏密码设置
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    长期存储口令    30s    check failed!    #回到长期存储口令界面
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/confirm2    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/confirm2
    Wait Until Page Contains    开启免口令登录    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Page Should Contain Text    已开启    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    25s
    ${pram1}    Evaluate    os.system('adb shell input tap 200 1143')    os    #key1
    log    ${pram1}
    ${pram2}    Evaluate    os.system('adb shell input tap 540 1143')    os    #key2
    log    ${pram2}
    ${pram3}    Evaluate    os.system('adb shell input tap 880 1143')    os    #key3
    log    ${pram3}
    ${pram4}    Evaluate    os.system('adb shell input tap 200 1324')    os    #key4
    log    ${pram4}
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity    #open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}
    ...    # automationName=appium    appPackage=com.cetcs.ecmapplication    # appActivity=.HomeActivity
    Wait Until Page Contains    加密功能已启用    20s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}    #验证结束
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!    #teardown
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Click Element    name=关闭
    Sleep    5s
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Close Application
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    600    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：开启免口令设置：终端屏幕解锁密码功能已开启
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，TF密码卡免口令登录功能关闭；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 点击免口令登录-》设置按钮；
    ...    3. 选择开启选项；
    ...    4. 点击关闭选项；
    ...    5. 点击手机home键退出密码卡管家，关闭终端屏幕解锁密码功能；再次点击APP图标进入应用；
    ...    6. 选择开启选项；"
    ...
    ...    预期结果：
    ...    "1. 成功进入安全设置界面；
    ...    2. 弹出长期存储口令设置界面；
    ...    3. 成功选择开启选项；
    ...    4. 成功选择关闭选项；
    ...    5. 成功进入长期存储口令设置界面；
    ...    6. 系统弹出请打开屏幕解锁密码功能的提示信息，点击确定跳转到终端手机设置解锁方式界面；点击取消停留在当前界面；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    #预置条件
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Wait Until Page Contains    设置    30s    check failed!
    Cswipe    250    650    250    250
    sleep    10s
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    数字密码    30s    check failed!
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Page Should Contain Text    输入您的数字密码
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    录入指纹    30s    check failed!
    Click Element    id=android:id/button2
    Close Application
    Sleep    10s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Page Should Contain Text    免口令登录    DEBUG
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    关闭
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    log    ${opened}
    sleep    10s
    Run Keyword If    ${opened}    Click Element    name=开启
    ...    ELSE    log    已开启
    sleep    10s
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/openautologin    30s    check failed!
    Wait Until Page Contains    开启免口令登录    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/mComplexEditText    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/simpleTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Wait Until Page Contains    已开启    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    20s    check failed!
    Click Element    name=关闭
    Click Element    name=确定
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    Sleep    30s
    #关闭锁屏数字密码
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    500    250    100
    Sleep    10s
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    Sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Page Should Contain Text    免口令登录    DEBUG
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    关闭
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    log    ${opened}
    sleep    10s
    Run Keyword If    ${opened}    Click Element    name=开启
    ...    ELSE    log    已开启
    sleep    10s
    Click Element    name=确定
    Wait Until Page Contains    安全提示    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_cancal2    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/distory_cancal2
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Click Element    name=确定
    Wait Until Page Contains    安全提示    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/distory_confirm2
    Wait Until Page Contains    解锁方式选择    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：关闭免口令设置
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，TF密码卡免口令登录功能已开启；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 点击免口令登录-》设置按钮；
    ...    3. 选择关闭选项；
    ...    4. 点击确定；
    ...    5. 重启手机，重启成功后点击APP图标启动应用；"
    ...
    ...    预期结果：
    ...    "1. 成功进入安全设置界面；
    ...    2. 弹出长期存储口令设置界面；
    ...    3. 成功选择关闭选项；
    ...    4. 成功设置，免口令设置已关闭
    ...    5. 进入密码卡管家登录界面；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    650    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    数字密码    30s    check failed!
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Page Should Contain Text    输入您的数字密码
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    录入指纹    30s    check failed!
    Click Element    id=android:id/button2
    Close Application
    Sleep    10s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    \    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    failed!
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    已开启
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    sleep    10s
    Wait Until Page Contains    长期存储口令    30s    sign in failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    sign in failed!
    Run Keyword If    ${opened}    Click Element    name=关闭
    ...    ELSE    log    已经关闭
    Click Element    name=确定
    Page Should Contain Text    关闭
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    20s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    ${pram}    Evaluate    os.system('adb shell reboot')    os
    log    ${pram}
    sleep    25s
    ${pram1}    Evaluate    os.system('adb shell input tap 200 1143')    os    #key1
    log    ${pram1}
    ${pram2}    Evaluate    os.system('adb shell input tap 540 1143')    os    #key2
    log    ${pram2}
    ${pram3}    Evaluate    os.system('adb shell input tap 880 1143')    os    #key3
    log    ${pram3}
    ${pram4}    Evaluate    os.system('adb shell input tap 200 1324')    os    #key4
    log    ${pram4}
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application
    Sleep    10s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    650    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：取消免口令设置
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，TF密码卡免口令登录功能已开启；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 点击免口令登录-》设置按钮；
    ...    3. 选择关闭选项；
    ...    4. 点击取消；
    ...    5. 重复步骤1-3，点击确定；
    ...    6. 重复步骤1-2，选择开启选项；
    ...    7. 点击取消；"
    ...
    ...    预期结果：
    ...    "1. 成功进入安全设置界面；
    ...    2. 弹出长期存储口令设置界面；
    ...    3. 成功选择关闭选项；
    ...    4. 未成功设置，当前免口令设置状态为开启；
    ...    5. 成功设置，免口令设置已关闭；
    ...    6. 成功选择开启选项；
    ...    7. 未成功设置，当前免口令设置状态为关闭；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Sleep    10s
    Cswipe    250    650    250    250
    Sleep    10s
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    数字密码    30s    check failed!
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Page Should Contain Text    输入您的数字密码
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    录入指纹    30s    check failed!
    Click Element    id=android:id/button2
    Close Application
    Sleep    20s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LoginActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    #预置条件-end
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    已开启
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    sleep    10s
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    check failed!
    Run Keyword If    ${opened}    Click Element    name=关闭
    ...    ELSE    log    已经关闭
    Click Element    name=取消
    Wait Until Page Contains    已开启    30s    check failed!
    sleep     10s
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    check failed!
    Run Keyword If    ${opened}    Click Element    name=关闭
    ...    ELSE    log    已经关闭
    Click Element    name=确定
    Wait Until Page Contains    关闭    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    check failed!
    Click Element    name=开启
    Click Element    name=取消
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Page Should Contain Text    关闭    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    #teardown-恢复环境
    Sleep    20s
    #关闭锁屏数字密码
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    650    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：开启口令重置提醒周期
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，未设置口令重置提醒周期；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 点击口令重置提醒周期-》设置按钮；
    ...    3. 选择开启选项，遍历选择所有的日期，点击确定；
    ...    4. 修改手机终端本地时间，遍历所有选择的日期，再次登录密码卡管家；"
    ...
    ...    预期结果：
    ...    "1. 成功进入安全设置界面；
    ...    2. 进入口令重置提醒设置界面；
    ...    3. 成功设置；
    ...    4. 提醒用户口令到期，需要修改？（根据设计）"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    #预置条件开启锁屏数字密码
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Sleep    10s
    Cswipe    250    650    250    250
    Sleep    10s
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    数字密码    30s    check failed!
    Click Element    name=数字密码
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Page Should Contain Text    输入您的数字密码
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    确认您的密码    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Wait Until Page Contains Element    id=com.android.settings:id/next_button    30s    check failed!
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    录入指纹    30s    check failed!
    Click Element    id=android:id/button2
    Close Application
    Sleep    20s
    #进入加密功能启用界面
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    #Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    ${restr}=    Run Keyword And Return Status    Page Should Contain Text    未设置提醒周期    DEBUG    #需预置未开启设置提醒周期
    Run Keyword If    '${restr}'=='false'    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_close
    ...    ELSE    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_open    #已开启    #未设置 待开启
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_open
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1040')    os    #一个月元素标签所在位置
    log    ${pram1}
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    1个月    DEBUG
    Page Should Contain Text    1个月 \ (距下次提醒： 30天)    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    1个月    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/textview_zhankai
    ${pram2}    Evaluate    os.system('adb shell input tap 156 1080')    os    #2个月元素标签所在位置
    log    ${pram2}
    Wait Until Page Contains    2个月    30s    check failed!
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    2个月    DEBUG
    Page Should Contain Text    2个月 \ (距下次提醒： 61天)    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    2个月    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/textview_zhankai
    ${pram3}    Evaluate    os.system('adb shell input tap 156 1120')    os    #3个月元素标签所在位置
    log    ${pram3}
    Wait Until Page Contains    3个月    30s    check failed!
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    3个月    DEBUG
    Page Should Contain Text    3个月 \ (距下次提醒： 91天)    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #teardown-恢复环境
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    口令重置提醒    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/cycle_tv_close
    Wait Until Page Contains    未设置提醒时间    30s    check failed!
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application
    Sleep    15s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.android.settings
    ...    appActivity=.HWSettings
    Cswipe    250    650    250    250
    Wait Until Page Contains    锁屏和密码    30s    check failed!
    Click Element    name=锁屏和密码
    Wait Until Page Contains    锁屏密码    30s    check failed!
    Click Element    name=锁屏密码
    Wait Until Page Contains    请输入解锁密码    30s    check failed!
    Wait Until Page Contains Element    id=com.android.settings:id/password_entry    30s    check failed!
    Input Password    id=com.android.settings:id/password_entry    1234
    Click Element    id=com.android.settings:id/next_button
    Wait Until Page Contains    无密码    30s    check failed!
    Click Element    name=无密码
    Wait Until Page Contains    关闭指纹校验功能    30s    check failed!
    Click Element    id=android:id/button1
    Wait Until Page Contains    无密码    30s    check failed!
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：关闭口令重置提醒周期
    [Documentation]    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，已设置口令重置提醒周期；" "1. 点击安全参数；
    ...    2. 点击口令重置提醒周期-》设置按钮；
    ...    3. 选择关闭选项，点击取消；
    ...    4. 重新点击设置按钮，再次进入口令重置提醒界面，选择关闭选项，点击确定；
    ...    5. 修改手机终端本地时间，遍历所有选择的日期，再次登录密码卡管家；
    ...    " "1. 成功进入安全设置界面；
    ...    2. 进入口令重置提醒设置界面；
    ...    3. 退出口令重置提醒界面；
    ...    4. 设置成功，口令重置提醒被关闭；
    ...    5. 密码卡管家登录后不再提醒用户口令到期；"
    [Tags]    安全检查(#641)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    30s
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains    口令重置提醒周期    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    口令重置提醒    30s    sign in failed!
    Wait Until Page Contains    到期后提醒用户修改密码卡口令    30s    sign in failed!
    Page Should Contain Text    个月    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_close
    Click Element    id=com.cetcs.ecmapplication:id/cancal3
    Wait Until Page Contains    个月    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_close
    Click Element    name=确定
    Page Should Contain Text    正在设置请稍后...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhishijianTV    30s    sign in failed!
    Page Should Contain Text    未设置提醒时间
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

【N】安全检查：安全设置时点击手机home键
    [Documentation]    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2.当前已进入安全设置界面；"
    ...    "1. 在安全设置界面点击home键返回手机桌面，再次点击APP图标启动应用；
    ...    2. 在点击免口令登录-》设置后点击手机home键返回手机桌面，再次点击APP图标启动应用；
    ...    3. 在点击口令重置提醒周期-》设置后点击手机home键返回手机桌面，再次点击APP图标启动应用；
    ...    4. 在口令重置提醒周期设置中提示“正在设置请稍后”时点击手机home键返回手机桌面，再次点击APP图标启动应用；
    ...    "
    ...    "1. 能成功进入安全设置界面；
    ...    2. 能成功进入长期存储口令设置界面；
    ...    3. 能成功进入口令重置提醒周期设置界面；
    ...    4. 能成功进入安全设置界面；
    ...    "
    [Tags]    安全检查(#641)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Press Keycode    3
    Click Element    密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Page Should Contain Text    免口令登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Press Keycode    3
    Wait Until Page Contains    免口令登录
    Page Should Not Contain Text    开启后无需输入口令即可登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Page Should Contain Text    口令重置提醒周期    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Page Should Contain Text    到期后提醒用户修改密码卡口令    DEBUG
    Press Keycode    3
    Wait Until Page Contains    口令重置提醒周期    30s    check failed!
    Page Should Not Contain Text    到期后提醒用户修改密码卡口令    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    到期后提醒用户修改密码卡口令    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_open
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1040')    os    #一个月元素标签所在位置
    log    ${pram1}
    Wait Until Page Contains    1个月    30s    check failed!
    Click Element    name=确定
    Page Should Contain Text    正在设置请稍后...
    Press Keycode    3
    Wait Until Page Contains    1个月 \ (距下次提醒： 29天)    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

【N】安全检查：安全设置时点击手机返回键
    [Documentation]    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2.当前已进入安全设置界面；" "1. 点击免口令登录-》设置后点击手机返回键；
    ...    2. 在点击口令重置提醒周期-》设置后点击手机返回键；
    ...    3. 在口令重置提醒周期设置中提示“正在设置请稍后”时点击手机返回键；
    ...    " "1. 成功返回安全设置界面；
    ...    2. 成功返回安全设置界面；
    ...    3. 口令重置提醒周期设置成功，并且成功返回安全设置界面。
    ...    "
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Page Should Contain Text    免口令登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Go Back
    Wait Until Page Contains    免口令登录
    Page Should Not Contain Text    开启后无需输入口令即可登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout    30s    check failed!
    Page Should Contain Text    口令重置提醒周期    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Page Should Contain Text    到期后提醒用户修改密码卡口令    DEBUG
    Go Back
    Wait Until Page Contains    口令重置提醒周期    30s    check failed!
    Page Should Not Contain Text    到期后提醒用户修改密码卡口令    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    到期后提醒用户修改密码卡口令    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_open
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1040')    os    #一个月元素标签所在位置
    log    ${pram1}
    Wait Until Page Contains    1个月    30s    check failed!
    Click Element    name=确定
    Page Should Contain Text    正在设置请稍后...
    Go Back
    Wait Until Page Contains    1个月 \ (距下次提醒： 29天)    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：安全加密算法检查
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 验证安全加密算法各子项是否正确；"
    ...
    ...    预期结果：
    ...    "1. 进入安全设置界面；
    ...    2. 安全加密算法各子项检查正常，内容与界面都显示正常；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    #进入加密功能启用界面
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    #Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    #Page Should Contain Element    id=com.cetcs.ecmapplication:id/algorithm_title    DEBUG
    #Click Element    id=com.cetcs.ecmapplication:id/algorithm_title
    #Cswipe    684    1324    684    906
    #sleep    5s
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/checkTitleTV    30s    check failed!
    Wait Until Page Contains    加密通讯会话密钥协商算法    30s    check failed!
    Wait Until Page Contains    SM2    30s    check failed!
    Wait Until Page Contains    密钥衍生算法    30s    check failed!
    Wait Until Page Contains    SM3    30s    check failed!
    Wait Until Page Contains    加密通讯语音加密算法    30s    check failed!
    Wait Until Page Contains    ZUC    30s    check failed!
    #Cswipe    684    1324    684    906
    Wait Until Page Contains    本地数据加密算法    30s    check failed!
    Wait Until Page Contains    SM4-CBC    30s    check failed!
    Wait Until Page Contains    密码管理消息加密算法    30s    check failed!
    Wait Until Page Contains    SM4-OFB    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】安全检查：安全有效性状态检查
    [Documentation]    预置条件：
    ...    "1. 密码卡管家已成功登录，进入加密功能已启用界面；"
    ...
    ...    操作步骤：
    ...    "1. 点击安全参数；
    ...    2. 验证安全有效性状态各子项是否正确；"
    ...
    ...    预期结果：
    ...    "1. 进入安全设置界面；
    ...    2. 安全有效性状态各子项检查正常，内容与界面都显示正常；"
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    sign in failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanshezhiTV    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/algorithm_title    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/effect_title    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Page Should Contain Text    安全设置    DEBUG
    Page Should Contain Text    免口令登录    DEBUG
    Page Should Contain Text    口令重置提醒周期    DEBUG
    Page Should Contain Text    检查安全加密算法    DEBUG
    Page Should Contain Text    检查安全有效性状态    DEBUG
    Page Should Contain Text    数字证书有效性    DEBUG
    Page Should Contain Text    密钥有效性    DEBUG
    Page Should Contain Text    密码管理软件版本    DEBUG
    Page Should Contain Text    已是最新版本
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】手动销毁功能：【取消销毁】取消
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM已登录"
    ...
    ...    操作步骤：
    ...    "1. 点击“销毁密码卡”按钮
    ...    2. 点击“下一步”按钮
    ...    3. 输入正确的口令，点击“下一步”按钮
    ...    4. 点击“取消”按钮"
    ...
    ...    预期结果：
    ...    "1. 跳转到销毁密码卡提醒界面，界面显示正常且符合设计，有准确的警示说明
    ...    2. 跳转到销毁密码卡口令输入界面，界面显示正常且符合设计
    ...    3. 弹出“是否确认销毁密码卡：销毁密码卡后将无法恢复”提示框
    ...    4. 返回到ECM主界面，密码卡未被销毁"
    [Tags]    手动销毁功能(#639)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    #预置条件-end
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou    DEBUG
    Page Should Contain Text    密码卡销毁后将会彻底清除密钥信息，加密通讯功能将无法使用，并且销毁后也不能自行恢复，请谨慎操作。    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    #点击下一步
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    ${OldVpwd}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/comfirm    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    #Wait Until Page Contains    是否确认销毁密码卡?    30s    check failed!
    #Page Should Contain Text    销毁密码卡后将无法恢复    DEBUG
    #Page Should Contain Text    是否确认销毁密码卡    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_cancal2    30s    check failed!
    #Click Element    id=com.cetcs.ecmapplication:id/distory_cancal2    #取消销毁密码按钮未响应
    #Click Element    name=取消    #点击按钮未响应
    ${pram1}    Evaluate    os.system('adb shell input tap 645 1120')    os    #取消按钮元素标签所在位置
    log    ${pram1}
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    #Wait Until Page Contains    密码卡已销毁    20s    operation failed!
    #Page Should Contain Text    加密功能无法继续使用，如需使用请到当地移动营业厅重新办理密码卡，详询10086
    #Page Should Contain Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    #sleep    10s
    #close application
    [Teardown]    Kill Adb Process    ecm

【N】手动销毁功能：【取消销毁】系统返回
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡
    ...    2. ECM已登录"
    ...
    ...    操作步骤：
    ...    "1. 点击“销毁密码卡”按钮
    ...    2. 点击“下一步”按钮
    ...    3. 输入正确的口令，点击“下一步”按钮
    ...    4. 点击系统的“返回”按钮
    ...    5. 点击系统的“返回”按钮"
    ...
    ...    预期结果：
    ...    "1. 跳转到销毁密码卡提醒界面，界面显示正常且符合设计，有准确的警示说明
    ...    2. 跳转到销毁密码卡口令输入界面，界面显示正常且符合设计
    ...    3. 弹出“是否确认销毁密码卡：销毁密码卡后将无法恢复”提示框
    ...    4. “是否确认销毁密码卡：销毁密码卡后将无法恢复”提示框消失，仍停留在当前界面
    ...    5. 返回到ECM主界面，密码卡未被销毁"
    [Tags]    手动销毁功能(#639)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou    DEBUG
    Page Should Contain Text    密码卡销毁后将会彻底清除密钥信息，加密通讯功能将无法使用，并且销毁后也不能自行恢复，请谨慎操作。    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    #点击下一步
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    ${OldVpwd}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/comfirm    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    #Wait Until Page Contains    是否确认销毁密码卡?    30s    check failed!    #识别不了该元素
    #Page Should Contain Text    销毁密码卡后将无法恢复    DEBUG
    #Page Should Contain Text    是否确认销毁密码卡    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/distory_cancal2    30s    check failed!    #取消销毁按钮元素
    Go Back    #系统返回
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Go Back
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    #Wait Until Page Contains    密码卡已销毁    20s    operation failed!
    #Page Should Contain Text    加密功能无法继续使用，如需使用请到当地移动营业厅重新办理密码卡，详询10086
    #Page Should Contain Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    #sleep    10s
    #close application
    [Teardown]    Kill Adb Process    ecm

【N】手动销毁功能：【口令场景】错误的口令（口令长度实现已变更）
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡，TF密码卡口令的当前允许错误输入次数为6次
    ...    2. 终端处于ECM销毁密码卡口令输入界面"
    ...
    ...    操作步骤："
    ...    1. 不输入口令，点击“下一步”按钮
    ...    2. 输入1位口令，点击“下一步”按钮
    ...    3. 输入5位口令，点击“下一步”按钮
    ...    4. 输入6位错误口令，点击“下一步”按钮
    ...    5. 输入16位错误口令（包含数字、字母和字符），点击“登录”按钮
    ...    6. 输入17位错误口令，点击“登录”按钮
    ...    7. 输入任意口令，点击“清空”按钮"
    ...
    ...    预期结果：
    ...    "1. 口令验证失败，停留在当前界面，弹出“请输入密码卡口令”提示
    ...    2. 口令验证失败，停留在当前界面，弹出“口令错误！再输错6次密码卡将被锁定”提示，口令自动被清空
    ...    3. 口令验证失败，停留在当前界面，弹出“口令错误！再输错6次密码卡将被锁定”提示，口令自动被清空
    ...    4. 口令验证失败，停留在当前界面，弹出“口令错误！再输错5次密码卡将被锁定”提示，口令自动被清空
    ...    5. 口令验证失败，停留在当前界面，弹出“口令错误！再输错4次密码卡将被锁定”提示，口令自动被清空
    ...    6. 口令验证失败，停留在当前界面，弹出“口令错误！再输错3次密码卡将被锁定”提示，口令自动被清空
    ...    7. 输入内容被清空，仍停留在当前界面"
    [Tags]    手动销毁功能(#639)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou    DEBUG
    Page Should Contain Text    密码卡销毁后将会彻底清除密钥信息，加密通讯功能将无法使用，并且销毁后也不能自行恢复，请谨慎操作。    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom    #点击下一步
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV    30s    check failed!
    #预置条件-end
    Click Element    id=com.cetcs.ecmapplication:id/comfirm    #不输入口令
    Wait Until Page Contains    销毁密码卡    30s    check failed!
    Page Should Not Contain Text    是否确认销毁密码卡?    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    1    #输入1位密码
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    口令长度错误,再输错5次密码卡将被锁定    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    12345    #输入5位密码
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    口令长度错误,再输错4次密码卡将被锁定    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    12345    #输入5位密码
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    再输错3次密码卡将被锁定    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    123457    #输入6位密码
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    再输错2次密码卡将被锁定    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    123457887654321    #输入16位密码
    Click Element    id=com.cetcs.ecmapplication:id/comfirm
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    再输错1次密码卡将被锁定    DEBUG
    Go Back
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    #Wait Until Page Contains    密码卡已销毁    20s    operation failed!
    #Page Should Contain Text    加密功能无法继续使用，如需使用请到当地移动营业厅重新办理密码卡，详询10086
    #Page Should Contain Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    #sleep    10s
    #close application
    [Teardown]    Kill Adb Process    ecm

【N】安全性及可靠性：检测APP运行时占用内存和泄露
    [Documentation]    预置条件：
    ...    "1、终端（手机）与电脑成功连接；
    ...    2、被测应用已成功安装到终端（手机）。"
    ...
    ...    操作步骤：
    ...    "1. 访问APP，保持APP运行状态（测试周期：半个小时、一个小时、半天、一天）；
    ...    2. 在PC端进入cmd命令行界面；
    ...    3. 输入adb shell dumpsys meminfo <package名称 / \ PID>或者使用DDMS，对APP界面和功能进行遍历测试、快速操作，检查是否存在内存泄露；"
    ...
    ...    预期结果：
    ...    "1. APP保持运行；
    ...    2. 成功进入；
    ...    3. 1、查看Native/Dalvik 的 Heap 信息，检测该值是否一直增长，如果一直增长则代表程序可能出现了内存泄漏；
    ...    2、查看Total 的 PSS 信息，检查占用内存大小是否超过研发标准；
    ...    3、APP运行一段时间，检查缓存占用大小是否超过研发标准。"
    [Tags]    安全性及可靠性(#654)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    [Teardown]    Kill Adb Process    ecm

【N】加密通话：连续发起多次加密电话
    [Documentation]    预置条件：
    ...    "1. 在网络连接正常、TF卡状态正常且与密管连接正常的情况下，主叫连续发起多次加密电话（分别测试连续发起5通、10通、15通、20通加密电话），检查接通率和密钥协商情况；
    ...    "
    ...    "1. 成功发起且被叫成功接听，密钥协商成功；
    ...    "
    [Tags]    加密通话(#678)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Press Keycode    3
    Press Keycode    5
    [Teardown]    Kill Adb Process    ecm
