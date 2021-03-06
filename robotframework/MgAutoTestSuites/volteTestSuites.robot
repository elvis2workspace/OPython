*** Settings ***
Suite Setup       Evaluate    os.system('adb shell input keyevent 82')    os
Suite Teardown    Run Keyword If Any Critical Tests Failed    Close Application    # 执行失败关闭应用程序
Library           AppiumLibrary
Library           CustomLibrary
Resource          test_mg_ecmapp_resource.robot

*** Test Cases ***
密码卡开机登录：正确的简单口令登录
    [Documentation]    预置条件:
    ...    1、"密码卡已成功激活，并且成功插入手机内存卡卡槽；
    ...    2、ECM已设置开机自启动。"
    ...
    ...
    ...    操作步骤：
    ...    "1、用户打开安全手机终端，进入密码卡登录界面；
    ...    2、 输入正确的密码卡简单口令。"
    ...
    ...    预期结果：
    ...    "1、密码卡登录界面显示正常；
    ...    2、 密码卡登录成功，成功进入ECM加密功能已启用的界面。"
    [Tags]    用户登录解锁
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/guanyuIV    INFO
    sleep    30S
    Close Application
    [Teardown]    Kill Adb Process    ecm

密码卡开机登录：错误的简单口令登录
    [Documentation]    预置条件:"1、密码卡被成功激活，并且成功插入手机内存卡卡槽；
    ...    2、ECM已设置开机自启动。"
    ...
    ...    操作步骤："1. 用户打开安全手机终端，进入密码卡登录界面
    ...    2. 输入错误的密码卡简单口令"
    ...
    ...    预期结果： "1. 密码卡登录界面UI显示正常
    ...    2. 提示密码卡口令错误，禁止用户登录。
    ...    "
    [Tags]    用户登录解锁
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    #需要选择不记住密码
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    123457    #输入错误密码卡简单口令
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Capture Page Screenshot    loginfailed
    sleep    10s
    Page Should Not Contain Text    加密功能已启用    DEBUG
    Page Should Contain Text    请输入密码卡口令    DEBUG
    sleep    10s
    Close Application

密码卡开机登录：正确的复杂口令登录
    [Documentation]    预置条件："密码卡被成功激活，并且成功插入手机内存卡卡槽。
    ...    ECM已设置开机自启动；"
    ...
    ...    操作步骤：
    ...    "1. 用户打开安全手机终端;
    ...    2. 在登录界面上输入正确的密码卡复杂口令;"
    ...
    ...    预期结果：
    ...    "1. 手机开机后跳转到密码卡登录界面，界面显示正常,符合UI设计;
    ...    2. 用户能成功登录，并且进入ECM加密功能已启动界面；"
    [Tags]    用户登录解锁
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Page Should Contain Text    使用复杂口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Contain Text    请再次输入新口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Wait Until Page Contains    修改口令成功    10s    change password failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    relogin failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application
    sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    operation failed!
    Input Password    id=id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${NewVpwd}
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    修改口令成功    10s    change password failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    10s    relogin failed! please check the password.
    Close Application

密码卡开机登录：错误的复杂口令登录
    [Documentation]    预置条件:"密码卡被成功激活，并且成功插入手机内存卡卡槽；
    ...    ECM已设置开机自启动；"
    ...
    ...    操作步骤："1. 用户打开安全手机终端
    ...    2. 在登录界面上输入错误的密码卡复杂口令"
    ...
    ...    预期结果：
    ...    "1. 开机后进入密码卡登录界面，界面样式显示正常，符合UI设计
    ...    2. 提示口令错误，不允许用户登录"
    [Tags]    用户登录解锁
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    sleep    10s
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Page Should Contain Text    使用复杂口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Contain Text    请再次输入新口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Wait Until Page Contains    修改口令成功    10s    change password failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    relogin failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application
    sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    volte2015    #错误的复杂口令
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Page Should Not Contain Text    加密功能已启用    #建立安全通道失败
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    Page Should Contain Text    请输入密码卡口令    #提示口令错误，不允许用户登录
    sleep    10s
    Close Application

APP登录：建立安全通道
    [Documentation]    预置条件:
    ...    "1、被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    2、TF卡与当前SIM卡成功绑定。 "
    ...
    ...    操作步骤："1. 打开APP，输入正确的登录口令；
    ...    2. 点击下拉系统通知栏，检查APP登录状态显示。"
    ...
    ...    预期结果："1. 成功进入安全通道建立界面；
    ...    2. 系统通知栏正确显示当前密码卡状态。（待完善）
    ...    "
    [Tags]    用户登录解锁
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    sleep    10S
    Page Should Contain Text    ${TELE_NUMBER}    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    INFO
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/guanyuIV    INFO
    CSwipe
    Wait Until Page Contains Element    id=com.android.systemui:id/notification_bt    30s    failed to open notification!
    Page Should Contain Text    加密功能已启用    DEBUG
    Page Should Contain Text    请放心使用加密通讯功能    DEBUG
    sleep    30S
    Close Application
    Kill Adb Process    ecm

APP登录：加密功能启用
    [Documentation]    预置条件:
    ...    "1、被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    2、TF卡与当前SIM卡成功绑定。 "
    ...
    ...    操作步骤: "1. 打开APP，输入正确的登录口令；
    ...    2. 安全通道成功建立，进入加密功能启用中；
    ...    3. 点击下拉系统通知栏，检查APP登录状态显示；
    ...    4. 点击修改口令；
    ...    5. 点击销毁密码卡；
    ...    6. 点击安全检查；"
    ...
    ...    预期结果: "1. 成功进入建立安全通道界面，加密功能启用界面：
    ...    2、如果加密功能启用成功则显示已绑定的手机号码，如果加密功能异常则跳转到异常提示界面；
    ...    3、该界面提供三个功能：修改口令、销毁密码卡、安全检查, 系统通知栏正确显示当前状态：加密功能启用中；
    ...    4. 成功跳转到修改口令界面；
    ...    5. 成功跳转到密码卡销毁界面；
    ...    6. 成功跳转到安全检查界面。"
    [Tags]    用户登录解锁
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!    #建立安全通道
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout
    CSwipe
    Wait Until Page Contains Element    id=com.android.systemui:id/notification_bt    30s    failed to open notification!
    Page Should Contain Text    加密功能已启用    DEBUG
    Page Should Contain Text    请放心使用加密通讯功能    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Text    请输入旧口令
    Go Back
    Go Back
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou
    Go Back
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains    已是最新版本
    Click Element    id=com.cetcs.ecmapplication:id/finishTV

密码卡异常，启动APP：密码卡已锁定(输入PIN码，解锁后登录APP）
    [Documentation]    预置条件："密码卡因连续输入6次口令被锁定，将已锁定的密码卡插入手机内存卡卡槽
    ...    手机已正常开机，并且成功进入手机桌面
    ...    已拨打10086获取该密码卡的PIN码
    ...    密码卡异常提示默认设置为不再提示"
    ...
    ...    操作步骤：
    ...    "1. 点击启动APP
    ...    2. 点击“输入PIN码”
    ...    3. 输入PIN码
    ...    4. 在修改口令界面上输入新口令后，然后再重复确认一次
    ...    5. 用户将终端手机重启
    ...    6. 点击APP"
    ...
    ...    预期结果:
    ...    "1. 进入APP “开机异常提示-已锁定”界面，界面样式符合UI设计
    ...    2. 系统跳转到PIN码输入界面，输入界面符合UI设计
    ...    3. PIN码成功输入，并且验证成功，提示密码卡已被解锁，直接跳转到修改口令界面
    ...    4. 密码修改成功
    ...    5. 重启后成功进入手机桌面
    ...    6. 进入APP登录界面，输入修改后的口令，APP能正常登录"
    [Tags]    用户登录解锁
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!    #建立安全通道
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

APP登录：勾选了记住登录口令
    [Documentation]    预置条件:
    ...    "1、被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    2、TF卡与当前SIM卡成功绑定。"
    ...
    ...    操作步骤:
    ...    "1. 开启被测应用，在登录界面勾选记住口令或者进入安全设置开启免口令登录；
    ...    2. 在APP中通过功能按钮退出，再重新打开APP；
    ...    3. 在APP中通过手机返回键退出，再重新打开APP。
    ...    4. 重启手机，再进入APP；"
    ...
    ...    预期结果： "1. 成功设置；
    ...    2. 直接跳过登录口令输入界面，成功进入APP主界面：正在建立安全通道；
    ...    3. 直接跳过登录口令输入界面，成功进入APP主界面：正在建立安全通道；
    ...    4. 直接跳过登录口令输入界面，成功进入APP主界面：正在建立安全通道。
    ...    "
    [Tags]    用户登录解锁
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Go Back
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!    #建立安全通道
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Go Back
    Go Back
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    #在APP中通过功能按钮退出，再重新打开APP；
    #重启手机再进入app
    Close Application

APP登录：开机正常登录
    [Documentation]    预置条件:
    ...    "1、被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    2、TF卡与当前SIM卡成功绑定；
    ...    3、APP未设置勾选记住登录口令；
    ...    4、APP未设置开机自启动。
    ...
    ...    需求描述
    ...    开机后，首次运行管理APP需验证用户身份，需弹出登录界面；
    ...    登录成功后，用户更换TF密码卡，需用户重新登录后才能正常使用TF密码卡。
    ...
    ...    验收标准
    ...    1、重启手机后，首次运行管理APP，弹出登录界面，输入正确口令后可正常登录；
    ...    2、成功登录后，拔出TF卡，插入另一张TF卡（口令和第一张不一致），运行管理APP，需弹出登录界面，输入正确口令后可正常登录；"
    ...
    ...    操作步骤: "1. 打开APP；
    ...    2. 输入正确的登录口令，点击确定；
    ...    3. 安全通道成功建立，进入加密功能启用中；
    ...    4. 加密功能启用成功；"
    ...
    ...    预期结果： "1. 成功进入APP登录口令输入界面：
    ...    1、键盘允许输入数字、字母、特殊字符；
    ...    3、登录界面提供记住口令、忘记口令。
    ...    2. 成功登录APP，进入安全通道建立界面；
    ...    3. 检查加密功能启用过程：
    ...    1、界面提示加密功能启用中；
    ...    2、该界面提供三个功能：修改口令、销毁密码卡、安全检查；
    ...    3、界面有无任何图形提示加密功能的检查等待过程；
    ...    4. 界面显示“已绑定XXXX（手机号码）”。
    ...    "
    [Tags]    用户登录解锁
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Close Application

密码卡异常，启动APP：密码卡已锁定(拨打10086获取PIN码）
    [Documentation]    预置条件:
    ...    "密码卡因连续输入6次口令被锁定，将已锁定的密码卡,sim卡插入手机内存卡卡槽
    ...    密码卡异常提示默认设置为不再提示
    ...    手机已正常开机，并且成功进入手机桌面"
    ...
    ...    操作步骤： "1. 点击启动APP
    ...    2. 点击“拨打10086，获取PIN码”
    ...
    ...    预期结果:
    ...    "1. 进入APP “开机异常提示-已锁定”界面，界面样式符合UI设计
    ...    2. 跳过加密功能，进入手机普通SIM卡拨打10086流程，并且能正常接通，联系客服获取PIN码
    ...    "
    [Tags]    用户登录解锁(#634)
    #暂不实现

密码卡异常，启动APP：密码卡已锁定(输入PIN码界面）
    [Documentation]    预置条件:
    ...    "密码卡因连续输入6次口令被锁定，将已锁定的密码卡插入手机内存卡卡槽
    ...    已拨打10086获取该密码卡的PIN码
    ...    手机已正常开机，并且成功进入手机桌面
    ...    密码卡异常提示默认设置为不再提示"
    ...
    ...    操作步骤："1. 点击启动APP；2. 点击“输入PIN码；”
    ...
    ...    "预期结果： "1. 进入APP “开机异常提示-已锁定”界面，界面样式符合UI设计
    ...    2. 系统跳转到输入PIN码界面，界面UI符合UI设计
    ...    "
    [Tags]    用户登录解锁(#634)
    #暂不实现

手机号码绑定：绑定流程
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、手机号码已经开通加密功能；
    ...    4、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤：
    ...    "1. 插入与当前TF卡绑定号码不一致的SIM卡；
    ...    2. 点击访问并登录被测应用；
    ...    3. 在加密功能启用界面检测到手机卡已更换，点击重新绑定；
    ...    4. 输入正确的手机号码，点击下一步；
    ...    5. 点击返回；
    ...    6. 输入正确的手机号码，点击下一步；
    ...    7. 点击发送验证码；
    ...    8. 输入正确的验证码，点击确定；
    ...    9. 点击返回；"
    ...
    ...    预期结果："1. 成功插入；
    ...    2. 成功登录，进入加密功能启用界面；
    ...    3. 成功进入绑定手机界面；
    ...    4. 成功进入验证码输入界面；
    ...    5. 成功返回绑定手机界面；
    ...    6. 成功进入验证码输入界面；
    ...    7. 输入的手机号码成功接收到服务器发送的验证码；
    ...    8. 提示手机号码与密码卡成功绑定；
    ...    9. 返回失败。
    ...    "
    [Tags]    手机号绑定(#635)
    #需要解绑定手机号

手机号码绑定：输入正确的手机号码绑定
    [Documentation]    预置条件："1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、手机号码已经开通加密功能；
    ...    4、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤："1. 输入正确的手机号码（已经开通加密功能）：
    ...    当前插入的SIM卡号；
    ...    2. 点击下一步；
    ...    3. 输入服务器发送的验证码，点击确定；"
    ...
    ...    预期结果："1. 成功输入并正确显示；
    ...    2. 成功进入验证码输入界面；
    ...    输入的手机号码成功收取到服务器发送的验证码；
    ...    3. 手机号码与密码卡成功绑定。
    ...    "
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
    Kill Adb Process    ecm

手机号码绑定：输入错误的手机号码绑定
    [Documentation]    预置条件："1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入不存在的手机号码，点击下一步；
    ...    2. 输入手机号码不满足位数，点击下一步；
    ...    3. 输入正确的手机号码但未开通加密功能，点击下一步；
    ...    4. 输入已经绑定其他TF卡的手机号码，点击下一步；
    ...    5. 不输入，点击下一步；"
    ...
    ...    预期结果："1. 提示手机号码输入错误，要求重新输入；
    ...    2. 下一步按钮置灰，不可操作；
    ...    3. 手机号码能正常接收到验证码的信息，输入验证码后，点击完成按钮，系统进入手机号码绑定失败的界面，提示该手机号码未开通加密功能；
    ...    4. 提示该号码已经绑定其他TF卡，不能再次绑定。（根据需求修改）
    ...    5. 下一步按钮置灰，不可操作。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    15881172614
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    15881172614    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Not Contain Element    id=com.cetcs.ecmapplication:id/verifyET    DEBUG
    Sleep    15s
    close application
    Kill Adb Process    ecm

手机号码绑定：输入正确的验证码
    [Documentation]    预置条件；"1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定流程；
    ...    4、当前为绑定手机号界面。"
    ...
    ...    操作步骤："1. 输入正确的手机号码，点击下一步；
    ...    2. 输入正确的验证码，点击确定；"
    ...
    ...    预期结果："1. 1、成功进入验证码输入界面；
    ...    2、输入的手机号码成功收取到服务器发送的验证码；
    ...    2. 绑定成功，提示密码卡初始化成功，点击“完成”，进入加密功能启用中界面
    ...    "
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

手机号码绑定：输入错误的验证码
    [Documentation]    预置条件:"1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定界面；
    ...    4、当前为绑定手机号界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码，点击下一步；
    ...    2. 输入不足位数和超出位数的验证码，点击确定；
    ...    3. 输入错误的验证码，点击确定；
    ...    4. 输入已验证过的验证码，点击确定；
    ...    5. 输入其他非数字内容；"
    ...
    ...    预期结果：
    ...    "1. 成功进入验证码输入界面；
    ...    2、输入的手机号码成功收取到服务器发送的验证码；
    ...    2. 确定置灰，在页面中央弹出“验证码错误”的提示，并且60秒后重发按钮变为可点击，文字为“重发”；
    ...    3. 绑定失败，在页面中央弹出“验证码错误”的提示，并且60秒后重发按钮变为可点击，文字为“重发”；
    ...    4. 绑定失败，在页面中央弹出“验证码错误”的提示，并且60秒后重发按钮变为可点击，文字为“重发”；
    ...    5. 不允许输入。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Input Text    id=com.cetcs.ecmapplication:id/verifyET    \    \    \ \    \    ${EMPTY}
    ...    \    \    \    \    123456
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/verifyET    30s    failed!
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/reSendCodeTV
    Page Should Contain Text    秒后重发    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

手机号码绑定：重发验证码
    [Documentation]    预置条件:
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定流程；
    ...    4、当前为绑定手机号界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码，点击下一步；
    ...    2. 检查界面上对重发验证码的设计；
    ...    3. 输入验证码，不点击确定，等待倒计时完成后，点击重发；
    ...    4. 不输入验证码，等待60秒倒计时结束，再次点击重发；
    ...    5. 不输入验证码，等待倒计时完成后，分别点击多次重发，点击次数在服务器限定的最大次数之内；
    ...    6. 点击重发的次数超过服务器限定的最大次数；"
    ...
    ...    预期结果：
    ...    "1. 1、成功进入验证码输入界面；2、输入的手机号码成功收取到服务器发送的验证码；
    ...    2. 1、界面提示60秒后才能重发验证码且进行倒计时，倒计时进行期间，获取验证码按钮置灰不可用；2、倒计时完成后，重发按钮变为可用状态；
    ...    3. 1、输入的手机号码成功收取到新的验证码；2、界面提示60秒后才能重发验证码且进行倒计时，倒计时进行期间，获取验证码按钮置灰不可用；3、倒计时完成后，重发按钮变为可用状态；
    ...    4. 1、输入的手机号码成功收取到新的验证码；2、界面提示60秒后才能重发验证码且进行倒计时，倒计时进行期间，获取验证码按钮置灰不可用；3、倒计时完成后，重发按钮变为可用状态；
    ...    5. 输入的手机号码成功收取到新的验证码；
    ...    6. 发送失败，输入的手机号码不能收取到新的验证码。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/reSendCodeTV
    Wait Until Page Contains    30秒后重发    40s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

手机号绑定：验证码过期
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定流程；
    ...    4、当前为绑定手机号界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码，点击下一步；
    ...    2. 检查验证码过期时间设计是否合理；
    ...    3. 在过期时间内绑定手机号；
    ...    4. 在过期时间点绑定手机号；
    ...    5. 超过过期时间绑定手机号；
    ...    6. 再次点击重新发送验证码；"
    ...
    ...    预期结果：
    ...    "1. 成功进入验证码输入界面；
    ...    2、输入的手机号码成功收取到服务器发送的验证码；
    ...    2. 验证码过期时间设计合理，符合常规（比如15~30分钟）；
    ...    3. 成功绑定；
    ...    4. 成功绑定；
    ...    5. 绑定失败，提示验证码错误。
    ...    6. 能成功重新发送号码，并且进入60秒倒计时。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

修改密码卡口令：修改口令界面
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面"
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改口令"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计(D01)"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    go back
    Wait Until Page Contains    请输入旧口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    close application

修改密码卡口令：成功修改口令（简单口令）
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 输入新口令
    ...    4. 再次输入新口令（与第一次输入保持一致）
    ...    5. 点击重新登录进入APP登录界面，输入新口令"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计(D01)
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 输入完成后，进入再次输入新口令界面，界面样式符合UI设计
    ...    4. 输入完成后，进入修改口令成功页面，界面样式符合UI设计
    ...    5. APP能成功登录，成功进入手机安全模式主界面"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    go back
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    123457
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    123457
    Wait Until Page Contains    修改口令成功    10s    change password failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

修改密码卡口令：使用复杂口令界面
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令”
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面，界面样式符合UI设计"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    go back
    Wait Until Page Contains    请输入旧口令    10s    change operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Page Should Contain Text    使用复杂口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    Page Should Not Contain Element    使用复杂口令
    Page Should Contain Text    使用简单口令
    go back
    go back
    Wait Until Page Contains    是否终止修改口令？    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Page Should Contain Text    加密功能已启用
    sleep    10s
    Close Application

修改密码卡口令：成功修改口令（复杂口令）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤："1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令
    ...    4. 输入复杂口令（字母与数字组合，大于等于8位，小于等于16位）
    ...    5. 再次输入新口令（与第一次输入保持一致）
    ...    6. 点击重新登录再次进入APP登录界面，使用新修改的复杂口令登录"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面
    ...    4. 输入完成后，进入再次输入新口令界面，界面样式符合UI设计
    ...    5. 输入完成后，进入修改口令成功页面，界面样式符合UI设计
    ...    6. APP能成功登录，进入手机安全模式主界面
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    go back
    Wait Until Page Contains    请输入旧口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Page Should Contain Text    使用复杂口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    Page Should Not Contain Element    使用复杂口令
    Page Should Contain Text    使用简单口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Contain Text    请再次输入新口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Wait Until Page Contains    修改口令成功    10s    change password failed!
    Click Element    id=com.cetcs.ecmapplication:id/relogoin
    Wait Until Page Contains    加密功能已启用    15s    relogin failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application
    #成功修改成复杂密码，并正常建立安全通道

修改密码卡口令：修改口令两次输入不一致（简单口令）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 输入新口令
    ...    4. 再次输入新口令，与第一次输入的口令不一致"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入再次输入新口令界面，界面样式符合UI设计
    ...    4. 系统提示输入口令不一致，请重新输入的提示信息，清空密码输入框，并且界面样式符合UI设计"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    123457    #简单密码两次不一致
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    123458
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/newPasswordErrorInfo    15s    operation failed!
    Page Should Contain Text    口令不匹配，请重新输入
    Page Should Contain Text    请再次输入新口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    go back
    go back
    Wait Until Page Contains    是否终止修改口令？    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Page Should Contain Text    加密功能已启用
    sleep    10s
    Close Application

修改密码卡口令：修改口令两次输入不一致（复杂口令）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令
    ...    4. 输入复杂口令（字母与数字组合，大于等于8位，小于等于16位
    ...    5. 再次输入新口令，与第一次输入不一致"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面 ，界面样式符合UI设计
    ...    4. 输入完成后，进入再次输入新口令界面，界面样式符合UI设计
    ...    5. 系统提示“密码不匹配，请重新输入”，并清空输入
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    ${NewVpwd}    #复杂密码两次不一致
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Contain Text    请再次输入新口令    #请再次输入新口令
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    volte2015
    Click Element    id=com.cetcs.ecmapplication:id/mComplexEditText
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/newPasswordErrorInfo    15s    operation failed!
    Page Should Contain Text    口令不匹配，请重新输入
    Page Should Contain Text    请再次输入新口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    go back
    go back
    Wait Until Page Contains    是否终止修改口令？    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/alertEnter
    Page Should Contain Text    加密功能已启用
    sleep    10s
    Close Application

修改密码卡口令：复杂口令（位数小于8位）
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令”
    ...    4. 输入复杂口令的位数小于8位（纯数字不连续或者纯字母不连续或者数字字母组合）"
    ...
    ...    预期结果：
    ...    "1. \ 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面 ，界面样式符合UI设计
    ...    4. 下一步按钮灰化，输入的密码不符合要求，不能进行下一步操作
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    1237654
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Not Contain Text    请再次输入新口令    #UI未出现下一步按钮
    sleep    10s
    close application

修改密码卡口令：复杂口令（位数大于16位）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令”
    ...    4. 输入复杂口令的位数大于16位（纯数字不连续或者纯字母不连续或者数字字母组合）"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计 \ 2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面 ，界面样式符合UI设计
    ...    4. 下一步按钮灰化，输入的密码不符合要求，不能进行下一步操作
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    autotestvolte2016
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Not Contain Text    请再次输入新口令    #UI未出现下一步按钮
    sleep    10s
    close application

修改密码卡口令：复杂口令（特殊字符）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令”
    ...    4. 输入复杂口令的位数在8-16位之间，但是包含特殊字符，然后点击”下一步“"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面 ，界面样式符合UI设计
    ...    4. 系统提醒用户”不支持特殊字符，请输入字母和数字组合的密码“，清空输入"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    1237654@
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Not Contain Text    请再次输入新口令    #UI未出现下一步按钮
    sleep    10s
    close application

修改密码卡口令：复杂口令（连续序列）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面"
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入正确的旧口令
    ...    3. 点击“使用复杂口令”
    ...    4. 输入复杂口令（连续纯数字序列，不连续纯数字序列，连续纯字母序列，不连续纯字母序列），并且位数在8-16位之间，点击下一步"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 输入成功后，进入输入新口令界面，界面样式符合UI设计
    ...    3. 进入设计密码卡口令-复杂口令页面 ，界面样式符合UI设计
    ...    4. 系统提醒用户“口令过于简单，请重新设置”，清空输入。"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    请输入新口令    10s    operation failed!
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    12345678
    ${pram1}    Evaluate    os.system('adb shell input tap 960 1700')    os
    log    ${pram1}
    Page Should Not Contain Text    请再次输入新口令    #UI未出现下一步按钮
    sleep    10s
    close application

修改密码卡口令：输入旧口令错误
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入错误的旧口令"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计 \ 2. 系统验证旧口令，提示用户旧口令错误，输入后，系统提示用户还能再次输入的次数"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/inputpinTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple
    Page Should Contain Text    忘记口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV
    sleep    10s
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    123457
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    10s    operation failed!
    Page Should Contain Text    请输入旧口令
    sleep    10s
    Close Application

修改密码卡口令：多次输入旧口令，密码卡被锁定
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改密码卡口令页面上输入错误的旧口令（输入6次错误的口令）"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 进入密码卡已被锁定的提示页面
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    close application

修改密码卡口令：PIN码解锁异常（超过5次输入错误）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡，并且成功插入手机内存卡卡槽
    ...    密码卡被锁定，用户进入重置密码卡口令页面"
    ...
    ...    操作步骤：
    ...    "1. 用户在重置密码卡口令页面上点击”输入PIN码“
    ...    2. 连续输入5次错误的PIN码"
    ...
    ...    预期结果：
    ...    "1. 系统进入PIN码认证页面，页面设计符合UI设计
    ...    2. 系统进入PIN码失效页面，提示用户”PIN因连续输入5次错误而失效，如需重置口令或解除锁定，请到中国移动当地营业厅办理“，详询10086。
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    close application

修改密码卡口令：忘记口令
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤："1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 在修改口令页面上点击“忘记口令”"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 系统进入重置密码卡口令页面，页面样式符合UI设计
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    close application

修改密码卡口令：忘记口令（重置口令）
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“修改密码卡口令”
    ...    2. 点击页面上“忘记口令”
    ...    3. 点击“输入PIN码”
    ...    4. 输入正确的PIN码
    ...    5. 输入新口令，然后确认新口令
    ...    6. 点击重新登录，输入新口令"
    ...
    ...    预期结果：
    ...    "1. 进入修改密码卡口令页面，页面样式符合UI设计
    ...    2. 进入密码卡口令重置页面，页面样式符合UI设计
    ...    3. 进入PIN码认证页面，页面样式符合UI设计
    ...    4. 系统直接跳转到设置密码卡口令页面，页面样式符合UI设计，输入新口令
    ...    5. 系统提示口令修改成功
    ...    6. APP能成功登录，进入手机安全模式主界面"
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    close application

修改密码卡口令：简单口令和复杂口令界面切换
    [Documentation]    操作步骤:
    ...    "1. 点击修改口令；
    ...    2. 输入正确的旧口令；
    ...    3. 不输入新口令，在简单口令设置界面，点击使用复杂口令；
    ...    4. 不输入新口令，在复杂口令设置界面，点击使用简单口令；
    ...    5. 在简单口令和复杂口令界面来回切换，观察界面显示；"
    ...
    ...    预期结果：
    ...    "1. 成功进入旧口令输入界面，界面设计合理且符合需求；
    ...    2. 成功输入并跳转到新口令设置界面（默认进入简单口令设置界面），界面设计合理且符合需求；
    ...    3. 成功跳转到复杂口令设置界面，界面设计合理且符合需求；
    ...    4. 成功跳转到简单口令设置界面，界面设计合理且符合需求；
    ...    5. 操作正确响应且界面正常显示（输入、键盘、文字）。
    ...    "
    [Tags]    修改密码卡口令(#636)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiugaiLayout
    close application

密码卡开机登录：输错密码6次，密码卡被锁定
    [Documentation]    预置条件：
    ...    TF卡，sim卡已成功插入手机卡槽，并且状态正常
    ...
    ...    操作步骤：
    ...    "1. 用户打开手机终端
    ...    2. 在登录界面上输入错误的登录密码，连续输入6次
    ...    3. 重启手机"
    ...
    ...    预期结果：
    ...    "1. 进入密码卡登录界面，界面样式符合UI设计
    ...    2. 输入六次后，系统跳转到密码卡被锁定界面，在通知栏提示用户密码卡已被锁定
    ...    3. 系统检测到密码卡被锁定，进入到密码卡被锁定界面（B04界面），并且在通知栏也显示密码卡被锁定"
    [Tags]    密码卡状态监控(#637)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    close application

密码卡异常：密码卡已锁定（通知栏提示密码卡异常）
    [Documentation]    预置条件：
    ...    "密码卡因连续输入6次口令被锁定，将已锁定的密码卡插入手机内存卡卡槽
    ...    密码卡异常提示默认为继续提示"
    ...
    ...    操作步骤：
    ...    "1. 用户打开手机终端
    ...    2. 点击手机返回键，返回手机桌面，并且查看手机通知栏
    ...    3. 点击通知栏的提示信息
    ...    4. 点击界面上点击“跳过，暂不使用加密功能”
    ...    5. 点击“继续提示“
    ...    6. 重启手机
    ...    7. 若在步骤3点击“不再提示”
    ...    8. 重启手机，再次开机"
    ...
    ...    预期结果：
    ...    "1. 系统检测密码卡异常，进入”开机异常提示-已锁定“界面，界面样式符合UI设计
    ...    2. 在手机通知栏处提示用户密码卡已被锁定的提示信息
    ...    3. 系统进入进入”开机异常提示-已锁定“界面，界面样式符合UI设计
    ...    4. 弹出“下次开机时是否提示密码卡异常？”的提示信息 \ 5. 退出应用，进入手机桌面
    ...    6. 开机时会提示密码卡异常，并且在手机通知栏也会显示密码卡异常的提示信息
    ...    7. 退出应用，进入手机桌面
    ...    8. 开机时系统不再检测密码卡异常，在手机通知栏处也不再显示密码卡异常的提示信息"
    [Tags]    密码卡状态监控(#637)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    close application

密码卡销毁：成功销毁
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面
    ...    密码卡异常提示默认设置为继续提示"
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“销毁密码卡”
    ...    2. 在密码卡销毁提醒页面点击下一步
    ...    3. 输入密码卡口令（简单口令或者复杂口令）
    ...    4. 点击“确定”按钮
    ...    5. 按HOME键返回系统桌面，再重新访问被测应用；
    ...    6. 重启手机
    ...    7. 点击通知栏的信息或者直接点击启动APP "
    ...
    ...    预期结果：
    ...    "1. 进入密码卡销毁提醒页面，页面样式符合UI设计
    ...    2. 进入销毁密码卡页面，页面样式符合UI设计
    ...    3. 系统弹出是否确认销毁密码卡提示信息，页面样式符合UI设计
    ...    4. 系统显示密码卡销毁中的界面 ，最后进入密码卡已销毁界面，在该界面上停留一秒，进入APP主页面，密码卡已被销毁界面
    ...    5. 被测应用仍然停留在密码卡已销毁界面；
    ...    6. 开机后系统进入“开机登录异常-密码卡已损坏”界面，返回手机桌面，查看手机通知栏，在手机通知栏处显示提示密码卡已损坏的提示信息,
    ...    7. 系统进入开机登录异常-密码卡已损坏的提示界面"
    [Tags]    手动销毁功能(#639)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    是否确认销毁密码卡    10s    operation failed!
    Page Should Contain Text    销毁密码卡后将无法恢复
    Click Element    id=com.cetcs.ecmapplication:id/distory_confirm2
    Wait Until Page Contains    密码卡已销毁    20s    operation failed!
    Page Should Contain Text    加密功能无法继续使用，如需使用请到当地移动营业厅重新办理密码卡，详询10086
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    sleep    10s
    close application

密码卡销毁：取消销毁
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“销毁密码卡”
    ...    2. 在密码卡销毁提醒页面点击下一步
    ...    3. 输入密码卡口令（简单口令或者复杂口令）
    ...    4. 点击“取消”按钮"
    ...
    ...    预期结果：
    ...    "1. 进入密码卡销毁提醒页面，页面样式符合UI设计
    ...    2. 进入销毁密码卡页面，页面样式符合UI设计
    ...    3. 系统弹出是否确认销毁密码卡提示信息，页面样式符合UI设计
    ...    4. 系统返回APP加密功能启用中界面，密码卡没有被销毁"
    [Tags]    手动销毁功能(#639)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}
    Wait Until Page Contains    是否确认销毁密码卡    10s    operation failed!
    Page Should Contain Text    销毁密码卡后将无法恢复
    Click Element    id=com.cetcs.ecmapplication:id/distory_cancal2
    Wait Until Page Contains    加密功能已启用    20s    operation failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    close application

密码卡销毁：输入错误口令，销毁不成功
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“销毁密码卡”
    ...    2. 在密码卡销毁提醒页面点击下一步
    ...    3. 输入错误的密码卡口令
    ...    4. 多次输入错误的密码卡口令（超过最大限制数）"
    ...
    ...    预期结果：
    ...    "1. 进入密码卡销毁提醒页面，页面样式符合UI设计
    ...    2. 进入销毁密码卡页面，页面样式符合UI设计
    ...    3. 提示密码卡口令错误，停留在输入密码页面,清空输入
    ...    4. 跳转到密码卡已锁定界面？"
    [Tags]    手动销毁功能(#639)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/destroy_tv_mimakahuihou
    Click Element    id=com.cetcs.ecmapplication:id/destroy_btn_bottom
    Wait Until Page Contains    销毁密码卡    10s    operation failed!
    Input Password    id=com.cetcs.ecmapplication:id/sdk2_pwd_edit_simple    ${OldVpwd}    #多次输入错误密码口令
    sleep    10s
    close application

用户体验测试：从不同地方访问应用
    [Documentation]    预置条件:
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 从通知栏访问被测应用；
    ...    2. 从系统桌面访问被测应用；"
    ...
    ...    预期结果：
    ...    "1. 成功访问并正确显示；
    ...    2. 成功访问并正确显示。"
    [Tags]    用户体验(#655)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    Sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains    加密功能已启用    30s    acess failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

密码卡安全参数设置：关闭定期删除加密通话记录
    [Documentation]    预置条件：
    ...    "1、被测应用已经准备就绪（成功安装在终端）；
    ...    2、终端（手机）已经准备就绪；
    ...    3、被测应用的安全检查设置中，定期删除加密通话记录为开启状态。"
    ...
    ...    操作步骤：
    ...    "1. 点击进入APP安全检查界面；
    ...    2. 选择定期删除加密通话记录，点击设置；
    ...    3. 点击关闭；
    ...    4. 点击取消；
    ...    5. 在安全检查设置界面，选择定期删除加密通话记录，点击设置；
    ...    6. 点击关闭；
    ...    7. 点击确定；
    ...    8. 点击进入APP其他界面后再返回安全检查界面，查看定期删除加密通话记录设置；
    ...    9. 按HOME键或者返回键退出APP，再进入APP查看定期删除加密通话记录设置；
    ...    10. 重启手机，再访问APP查看定期删除加密通话记录设置；
    ...    11. 当使用周期到达历史指定的删除加密通话记录设置的时间，访问加密通话记录；"
    ...
    ...    预期结果：
    ...    "1. 成功进入且界面设计符合用户预期；
    ...    2. 成功进入设置界面，设置项中“开启”为选中状态且正确显示用户设置；
    ...    3. 1、清空用户设置，取消开启的勾选状态且提示未设置删除周期；
    ...    2、“关闭”为选中状态；
    ...    4. 设置失败，返回安全检查设置界面；
    ...    5. 成功进入设置界面，设置项中“开启”为选中状态且正确显示用户设置；
    ...    6. 1、清空用户设置，取消开启的勾选状态且提示未设置删除周期；
    ...    2、“关闭”为选中状态；
    ...    7. 成功设置并正确保存；
    ...    8. 成功进入设置界面，设置项中“关闭”为选中状态；
    ...    9. 成功进入设置界面，设置项中“关闭”为选中状态；
    ...    10. 成功进入设置界面，设置项中“关闭”为选中状态；
    ...    11. 没有到期删除提示。"
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
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Close Application

密码卡安全参数设置：开启定期删除加密通话记录
    [Documentation]    预置条件:
    ...    "1、被测应用已经准备就绪（成功安装在终端）；
    ...    2、终端（手机）已经准备就绪；
    ...    3、被测应用的安全检查设置中，定期删除加密通话记录为关闭状态。"
    ...
    ...    操作步骤：
    ...    "1. 点击进入APP安全检查界面；
    ...    2. 选择定期删除加密通话记录，点击设置；
    ...    3. 点击开启；
    ...    4. 勾选控件提供的任意一个设置项；
    ...    5. 点击取消；
    ...    6. 在安全检查设置界面，选择定期删除加密通话记录，点击设置；
    ...    7. 点击开启并重新勾选提醒时间；
    ...    8. 点击确定；
    ...    9. 点击进入APP其他界面后再返回安全检查界面，查看定期删除加密通话记录设置；
    ...    10. 按HOME键或者返回键退出APP，再进入APP查看定期删除加密通话记录设置；
    ...    11. 重启手机，再访问APP查看定期删除加密通话记录设置；
    ...    12. 当使用周期到达指定期删除加密通话记录设置的时间，访问加密通话记录；
    ...    13. 在删除提示中点击确定；"
    ...
    ...    预期结果：
    ...    "1. 成功进入且界面设计符合用户预期；
    ...    2. 成功进入设置界面，设置项中“关闭”为选中状态；
    ...    3. 1、自动弹出选择提醒时间的控件，控件一共有30个选项：1天、2天、3天、.....、29天、30天；
    ...    2、控件中提供的选项只能单选，不能多选；
    ...    4. 成功勾选，控件由展开状态自动转化为收缩状态，开启设置正确显示为勾选的设置项；
    ...    5. 设置失败，返回安全检查设置界面；
    ...    6. 成功进入设置界面，设置项中“关闭”为选中状态；
    ...    7. 成功勾选，控件由展开状态自动转化为收缩状态，开启设置正确显示为勾选的设置项；
    ...    8. 成功设置并正确保存；
    ...    9. 成功进入设置界面，设置项中“开启”为选中状态且提醒周期为设置的时间；
    ...    10. 成功进入设置界面，设置项中“开启”为选中状态且提醒周期为设置的时间；
    ...    11. 成功进入设置界面，设置项中“开启”为选中状态且提醒周期为设置的时间；
    ...    12. 弹出到期删除记录提示，提示信息正确且设计合理；
    ...    13. 成功删除全部加密通话记录。"
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
    sleep    10s
    Close Application

密码卡安全参数设置：口令重置提醒关闭
    [Documentation]    预置条件：
    ...    " 密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面
    ...    口令重置提醒设置默认为开启（当前时间未处于提醒设置范围之内，登录时不需要提醒重置口令）"
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“安全检查”
    ...    2. 点击口令重置提醒周期上的“设置”按钮
    ...    3. 选择”关闭“选择框，点击确定按钮"
    ...
    ...    预期结果：
    ...    "1. 系统进入安全检查页面，页面样式符合UI设计
    ...    2. 弹出口令重置提醒弹出框，默认状态为”开启“，并且显示提醒周期，页面样式符合UI设计
    ...    3. 口令重置提醒设置被关闭，系统返回到安全检查页面"
    [Tags]    安全检查(#641)
    ${pram}    Evaluate    os.system('adb shell pm clear com.cetcs.ecmapplication')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    30s
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains    口令重置提醒周期    30s    30s
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    口令重置提醒    30s    sign in failed!
    Wait Until Page Contains    到期后提醒用户修改密码卡口令    30s    sign in failed!
    Page Should Contain Text    个月    \    #默认口令重置提醒为开启
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_close
    Click Element    name=确定
    Page Should Contain Text    正在设置请稍后...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhishijianTV    30s    sign in failed!
    Page Should Contain Text    未设置提醒时间
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

密码卡安全参数设置：口令重置提醒：开启
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面
    ...    口令重置提醒设置默认为关闭"
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“安全参数”
    ...    2. 点击口令重置提醒周期上设置按钮
    ...    3. 选择”开启“选择框，选择设置提醒时间，（验证各种时间）然后点击确定按钮"
    ...
    ...    预期结果：
    ...    "1. 系统进入安全检查页面，页面样式符合UI设计
    ...    2. 弹出口令重置提醒弹出框，默认状态为”关闭“，页面样式符合UI设计
    ...    3. 口令重置提醒周期设置成功，返回到安全检查界面，在口令重置提醒区域 显示设置的口令提醒周期"
    [Tags]    安全检查(#641)
    ${pram}    Evaluate    os.system('adb shell pm clear com.cetcs.ecmapplication')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains    口令重置提醒周期
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/shezhi2IV
    Wait Until Page Contains    口令重置提醒    30s    sign in failed!
    Wait Until Page Contains    到期后提醒用户修改密码卡口令    30s    sign in failed!
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_close
    Click Element    id=com.cetcs.ecmapplication:id/radiobutton_open
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/textview_zhankai    30s    sign in failed!
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1040')    os    #一个月元素标签所在位置
    log    ${pram1}
    Click Element    name=确定
    Page Should Contain Text    正在设置请稍后...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhishijianTV    30s    sign in failed!
    Page Should Contain Text    1个月
    Sleep    10s
    Close Application

密码卡安全参数设置：免口令设置：关闭
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面
    ...    免口令设置已经设置为开启 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上”安全检查“
    ...    2. 点击安全设置页面上免口令登录的 设置按钮
    ...    3. 在弹出框上选择”关闭“选项，然后点击确定按钮
    ...    4. 重启手机，再次点击APP"
    ...
    ...    预期结果：
    ...    "1. 进入安全检查页面，界面样式符合UI设计
    ...    2. 弹出免口令登录设置提示信息框，界面设计符合UI设计
    ...    3. 免口令登录被成功关闭，系统返回安全参数设置页面
    ...    4. APP不能直接登录，需要输入密码卡口令才能进行登录"
    [Tags]    安全检查(#641)
    ${pram}    Evaluate    os.system('adb shell pm clear com.cetcs.ecmapplication')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
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
    close application
    #需要重启手机
    #sleep    30s

密码卡安全设置：免口令设置：开启
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“安全参数”
    ...    2. 点击“免口令登录“的设置按钮
    ...    3. 选择开启项，然后点击确定按钮
    ...    4. 点击返回，退出被测应用；
    ...    5. 重新访问APP；
    ...    6. 重启手机，再访问APP；"
    ...
    ...    预期结果：
    ...    "1. 进入安全检查页面，页面样式符合UI设计
    ...    2. 弹出免口令登录设置页面，页面样式符合UI设计
    ...    3. 免口令设置正常开启，成功返回到被测应用主界面；
    ...    4. 成功返回到系统桌面；
    ...    5. 无需输入密码成功登录；
    ...    6. 无需输入密码成功登录；"
    [Tags]    安全检查(#641)
    ${pram}    Evaluate    os.system('adb shell pm clear com.cetcs.ecmapplication')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    #Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    30s    sign in failed!
    Page Should Contain Text    免口令登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    关闭
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    log    ${opened}
    sleep    10s
    Run Keyword If    ${opened}    Click Element    name=开启
    ...    ELSE    log    已开启
    sleep    10s
    Click Element    name=确定
    Page Should Contain text    已开启
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    Sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    Close Application

密码卡安全参数：安全检查正常
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤:
    ...    "1. 点击APP加密功能启用中界面上“安全参数”
    ...    2. 点击“完成”按钮"
    ...
    ...    预期结果：
    ...    "1. 进入安全设置页面，系统自动进行安全加密算法检查？？页面样式符合UI设计？？
    ...    2. 系统返回APP加密功能启用中界面， 安全检查完成？"
    [Tags]    安全检查(#641)
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    #Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains    检查安全加密算法    30s    check failed!
    Wait Until Page Contains    数字证书有效性    30s    check failed!
    Wait Until Page Contains    密钥有效性    30s    check failed!
    Wait Until Page Contains    已是最新版本    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

密码卡安全参数设置
    [Documentation]    预置条件：
    ...    "密码卡，SIM卡状态正常，并且成功插入手机内存卡卡槽
    ...    启动APP并且已成功登录，进入APP加密功能启用中界面 "
    ...
    ...    操作步骤：
    ...    "1. 点击APP加密功能启用中界面上“安全参数”
    ...
    ...    预期结果：
    ...    "1. 系统进入安全检查页面，页面样式符合UI设计
    ...    "
    [Tags]    安全检查(#641)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    #Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    #Click Element    id=com.cetcs.ecmapplication:id/loginBT
    #Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    sleep    15s
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    30s    sign in failed!
    #页面样式符合UI设计
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanshezhiTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/koulingchongzhishijianTV
    Wait Until Page Contains    检查安全加密算法    30s    check failed!
    Wait Until Page Contains    检查安全有效性状态    30s    check failed!
    Wait Until Page Contains    数字证书有效性    30s    check failed!
    Wait Until Page Contains    密钥有效性    30s    check failed!
    Wait Until Page Contains    密码管理软件版本    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    15s
    Close Application
    [Teardown]    Kill Adb Process    ecm

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
    Evaluate    os.system('adb shell input keyevent 3')    os
    Wait Until Page Contains    密码卡管家    15s    check failed!
    Click Element    name=密码卡管家
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginHint    15s    check failed!    #登录提示
    Page Should Contain Text    请输入密码卡口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG    #密码输入框
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/loginBT    DEBUG    #登录按钮
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/rememberLayout    DEBUG    #记住口令
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/forgetPWD    DEBUG    #忘记密码
    sleep    30s    #待系统稳定
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
    Kill Adb Process    ecm
    sleep    20s
    Cswipe    250    0    250    500
    Wait Until Page Contains    密码卡未登录    10s    failed!
    Page Should Contain Text    无法使用加密通讯功能    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/tvtryagain
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
    sleep    15s
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
    [Tags]    用户登录解锁(#634)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG    #不输入密码是点击登录按钮
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    1
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    60s    check failed!
    Page Should Contain Text    口令长度错误！剩余5次输入    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    60s    check failed!
    Page Should Contain Text    口令长度错误！剩余4次输入    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    123457
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    60s    check failed!
    Page Should Contain Text    口令错误！剩余3次输入次数    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error123456
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    60s    check failed!
    Page Should Contain Text    口令错误！剩余2次输入次数    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error1234567    #实现与描述不符
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorTV    60s    check failed!
    Page Should Contain Text    口令错误！剩余1次输入次数    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    12345error1234567
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

~【N】用户登录解锁:【口令场景】连续输入6次错误口令
    [Documentation]    预置条件：
    ...    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡，TF密码卡口令的当前允许错误输入次数为6次
    ...    2. ECM未开启“记住口令”和“免口令登录”开关
    ...    3. 终端处于ECM登录界面"
    ...
    ...    操作步骤：
    ...    "1. 连续输入6次错误口令进行登录
    ...    2. 检查通知栏
    ...    3. 点击通知栏上的ECM信息"
    ...
    ...    预期结果：
    ...    "1. 前5次输入错误口令均弹出“口令长度错误！剩余N次输入”提示，N从5到1随着输入次数的增加每次递减1，口令均自动被清空，且始终停留在当前界面；第6次输入错误口令后，跳转到“密码卡已锁定”界面，同时弹出“密码模块异常”提示，界面显示正常且符合设计，有准确的帮助说明、“拨打10086获取PIN码”、“输入PIN码”和“跳过，暂不使用加密功能”按钮
    ...    2. 通知栏提示“密码卡已锁定：密码卡已锁定，请输入PIN码解锁”
    ...    3. 跳转到“密码卡已锁定”界面，同时弹出“密码模块异常”提示"
    [Tags]    用户登录解锁(#634)    U
    [Setup]    Kill Adb Process    ecm
    ${pram}    Evaluate    os.system('adb shell pm clear westone.md.enterprisecontracts')    os
    log    ${pram}
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    app=${ECMApp}    automationName=appium
    ...    appPackage=com.cetcs.ecmapplication    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    close application
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
    Kill Adb Process    ecm
    Sleep    30s
    Cswipe    250    0    250    500
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    请放心使用加密通讯功能    DEBUG
    Click Element    name=加密功能已启用
    Wait Until Page Contains    ${TELE_NUMBER}    30s    check failed!
    Page Should Contain Text    加密功能已启用    DEBUG
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

~【N】修改密码卡口令：输入错误的旧口令
    [Documentation]    预置条件：
    ...    "1.密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 密码卡管家未记住密码，也未设置免口令登录；"
    ...
    ...    操作步骤：
    ...    "1. 点击修改口令按钮；
    ...    2. 不输入旧口令，点击确定；
    ...    3. 输入错误的旧口令，点击确定；
    ...    4. 再次输入错误的旧口令，点击确定；
    ...    5. 输入6次错误口令，点击确定；"
    ...
    ...    预期结果：
    ...    "1. 正常跳转到修改口令：请输入旧口令界面，界面显示正常；
    ...    2. 提示用户请输入口令；
    ...    3. 清空输入，并且提示口令剩余次数；
    ...    4. 清空输入，提示口令剩余次数，验证提示次数是否正确；
    ...    5. 提示密码卡被锁定，进入密码卡锁定界面；"
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
    Wait Until Page Contains    请输入旧口令    10s    change password operation failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG
    Page Should Contain Text    忘记口令    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/buttonTV    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV    #不输入口令点击确定
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG    #页面显示正常（提示用户请输入口令）
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    123457
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    再输错5次密码卡将被锁定    DEBUG
    sleep    10s
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
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/mComplexEditText    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    12345    #小于六位的新口令
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV    #点击下一步
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    请输入6-16位数字、字母、或二者的组合    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    12345678987654321    #大于16位
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/errorInfo    30s    check failed!
    Page Should Contain Text    请输入6-16位数字、字母、或二者的组合    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请输入新口令    30s    check failed!
    Page Should Not Contain Text    请再次输入新口令    DEBUG
    Input Password    id=com.cetcs.ecmapplication:id/mComplexEditText    volteecm    #全字母
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains    请再次输入新口令    30s    check failed!
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
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Click Element    name=关闭
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}
    [Teardown]    Kill Adb Process    ecm

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
    Wait Until Page Contains    再输错5次密码卡将被锁定    30s    sign in failed!
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
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/resetTitle    check failed!    check failed!
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/resetInfo    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/reset    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/ellipseButton    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/pinButton    DEBUG
    Page Should Contain Text    请输入有效的PIN码后    DEBUG
    Page Should Contain Text    重置密码卡口令    DEBUG
    Page Should Contain Text    拨打10086获取PIN码    DEBUG
    Page Should Contain Text    输入PIN码    DEBUG
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
    [Documentation]    "1. 密码卡管家已成功登录，进入加密功能已启用界面；
    ...    2. 终端屏幕解锁密码功能已开启；
    ...    3. ECM应用中，TF密码卡免口令登录功能关闭；" "1. 点击安全参数；
    ...    2. 点击免口令登录-》设置按钮；
    ...    3. 选择开启选项；
    ...    4. 点击关闭选项；
    ...    5. 点击手机home键退出密码卡管家，关闭终端屏幕解锁密码功能；再次点击APP图标进入应用；
    ...    6. 选择开启选项；
    ...    " "1. 成功进入安全设置界面；
    ...    2. 弹出长期存储口令设置界面；
    ...    3. 成功选择开启选项；
    ...    4. 成功选择关闭选项；
    ...    5. 成功进入长期存储口令设置界面；
    ...    6. 系统弹出请打开屏幕解锁密码功能的提示信息，点击确定跳转到终端手机设置解锁方式界面；点击取消停留在当前界面；
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
    sleep    10s
    Click Element    id=com.cetcs.ecmapplication:id/anquanLayout
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingdengluTV    30s    sign in failed!
    Page Should Contain Text    免口令登录    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    failed!
    ${opened}=    Run Keyword And Return Status    Page Should Contain Text    关闭
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    log    ${opened}
    sleep    10s
    Run Keyword If    ${opened}    Click Element    name=开启
    ...    ELSE    log    已开启
    sleep    10s
    Click Element    name=确定
    Page Should Contain text    已开启
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application
    Sleep    30s
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.HomeActivity
    Wait Until Page Contains    加密功能已启用    10s    setup failed!
    Page Should Contain Text    ${TELE_NUMBER}
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
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LoginActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能已启用    30s    sign in failed!
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
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
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    sleep    10s
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    check failed!
    Run Keyword If    ${opened}    Click Element    name=关闭
    ...    ELSE    log    已经关闭
    Click Element    name=确定
    Page Should Contain Text    关闭    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/miankoulingshezhiLayout
    Wait Until Page Contains    长期存储口令    30s    check failed!
    Wait Until Page Contains    开启后无需输入口令即可登录    30s    check failed!
    Click Element    name=开启
    Click Element    name=确定
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/openautologin    30s    check failed!
    Page Should Contain Text    开启免口令登录    DEBUG
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/simpleTV
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/yikaiqiTV    30s    check failed!
    Page Should Contain Text    已开启    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishTV    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
    Close Application

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
    #开启锁屏数字密码
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
    Sleep    5s
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
    Wait Until Page Contains    正在设置请稍后...    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    1个月    DEBUG
    Page Should Contain Text    1个月 \ (距下次提醒： 29天)    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    1个月    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/textview_zhankai
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1080')    os    #2个月元素标签所在位置
    log    ${pram1}
    Click Element    name=确定
    Wait Until Page Contains    正在设置请稍后...    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    2个月    DEBUG
    Page Should Contain Text    2个月 \ (距下次提醒： 59天)    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqishezhiLayout
    Wait Until Page Contains    2个月    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/textview_zhankai
    ${pram1}    Evaluate    os.system('adb shell input tap 156 1120')    os    #3个月元素标签所在位置
    log    ${pram1}
    Click Element    name=确定
    Wait Until Page Contains    正在设置请稍后...    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/koulingchongzhitixingzhouqiTV    30s    check failed!
    Page Should Contain Text    3个月    DEBUG
    Page Should Contain Text    3个月 \ (距下次提醒： 89天)    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishTV
    Wait Until Page Contains    加密功能已启用    30s    check failed!
    Page Should Contain Text    ${TELE_NUMBER}
    sleep    10s
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

~【N】手动销毁功能：【口令场景】连续输入6次错误口令
    [Documentation]    "1. 终端已安装有效的移动SIM卡和正常状态的TF密码卡，TF密码卡口令的当前允许错误输入次数为6次
    ...    2. 终端处于ECM销毁密码卡口令输入界面" "1. 连续输入6次长度大于5的错误口令进行销毁
    ...    2. 检查通知栏
    ...    3. 点击通知栏上的ECM信息
    ...    " "1. 前5次输入错误口令均弹出“口令错误！再输错N次密码卡将被锁定”提示，N从5到1随着输入次数的增加每次递减1，口令均自动被清空，且始终停留在当前界面；第6次输入错误口令后，跳转到“密码卡已锁定”界面，同时弹出“密码模块异常”提示，界面显示正常且符合设计，有准确的帮助说明、“拨打10086获取PIN码”、“输入PIN码”和“跳过，暂不使用加密功能”按钮
    ...    2. 通知栏提示“密码卡已锁定：密码卡已锁定，请输入PIN码解锁”
    ...    3. 跳转到“密码卡已锁定”界面，同时弹出“密码模块异常”提示
    ...    "
    [Tags]    手动销毁功能(#639)    U
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
    Input Password    id=com.cetcs.ecmapplication:id/inputpinTV    1234578987654321    #输入17位密码
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

~【N】手机号绑定：输入的手机号码非当前插入的sim卡号码
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、手机号码已经开通加密功能；
    ...    4、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码（已经开通加密功能），但是非当前插入手机的sim卡的号码；
    ...    2. 点击下一步；
    ...    3. 输入服务器发送的验证码，点击确定；"
    ...
    ...    预期结果：
    ...    "1. 成功输入并正确显示；
    ...    2. 成功进入验证码输入界面；输入的手机号码成功收取到服务器发送的验证码；
    ...    3. 手机号码与密码卡无法成功绑定；检测到绑定的号码不是当前插入手机的sim卡的号码；"
    [Tags]    手机号绑定(#635)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${OTHERECM_TELE}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】手机号码绑定：输入错误的手机号码绑定
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入不存在的手机号码，点击下一步；
    ...    2. 输入手机号码不满足位数，点击下一步；
    ...    3. 输入正确的手机号码但未开通加密功能，点击下一步；
    ...    4. 输入已经绑定其他TF卡的手机号码，点击下一步；
    ...    5. 不输入，点击下一步；"
    ...
    ...    预期结果：
    ...    "1. 提示手机号码输入错误，要求重新输入；
    ...    2. 提示手机号错误
    ...    3. 手机号码能正常接收到验证码的信息，输入验证码后，点击完成按钮，系统进入手机号码绑定失败的界面，提示该手机号码未开通加密功能；
    ...    4. 提示该号码已经绑定其他TF卡，不能再次绑定。（根据需求修改）
    ...    5. 提示请输入手机号码。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    15881172614
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    15881172614    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Not Contain Element    id=com.cetcs.ecmapplication:id/verifyET    DEBUG
    Sleep    15s
    close application
    Kill Adb Process    ecm

【N】手机号码绑定：输入错误的验证码
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定界面；
    ...    4、当前为绑定手机号界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码，点击下一步；
    ...    2. 删除自动填充的验证码，输入错误的验证码，点击确定；
    ...    3. 输入已验证过的验证码，点击确定；
    ...    4. 输入其他非数字内容；"
    ...
    ...    预期结果：
    ...    "1. 成功进入验证码输入界面，验证码自动填充；
    ...    2. 在页面中央弹出“验证码错误”的提示，并且60秒后重发按钮开始倒计时；60秒结束后，文字为“重发”；
    ...    3 在页面中央弹出“验证码错误”的提示，并且60秒后重发按钮开始倒计时；60秒结束后，文字为“重发”；
    ...    3. 提示验证码错误；
    ...    4. 不允许输入。"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Input Text    id=com.cetcs.ecmapplication:id/verifyET    12345    #输入错误验证码
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/verifyET    30s
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/reSendCodeTV
    Page Should Contain Text    秒后重发    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

【N】手机号码绑定：重发验证码
    [Documentation]    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定流程；
    ...    4、当前为绑定手机号界面。" "1. 输入正确的手机号码，点击下一步；
    ...    2. 检查界面上对重发验证码的设计；
    ...    3. 自动填充验证码后，不点击确定，等待倒计时完成后，点击重发；
    ...    4. 删除自动填充的验证码，等待60秒倒计时结束，再次点击重发；
    ...    5. 删除自动填充的验证码，等待倒计时完成后，分别点击多次重发，点击次数在服务器限定的最大次数之内；
    ...    6. 点击重发的次数超过服务器限定的最大次数；
    ...    " "1. 成功进入验证码输入界面；
    ...    2. 界面提示60秒后才能重发验证码且进行倒计时，倒计时进行期间，获取验证码按钮置灰不可用；
    ...    3. 倒计时完成后，重发按钮变为可用状态；
    ...    4. 输入的手机号码成功收取到新的验证码；
    ...    5. 输入的手机号码成功收取到新的验证码；
    ...    6. 发送失败，输入的手机号码不能收取到新的验证码。
    ...    "
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    重发验证码    65s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/reSendCodeTV
    Wait Until Page Contains    30秒后重发    40s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

【N】手机号绑定：验证码过期
    [Documentation]    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、成功进入手机号码绑定流程；
    ...    4、当前为绑定手机号界面。" "1. 输入正确的手机号码，点击下一步；
    ...    2. 检查验证码过期时间设计是否合理；
    ...    3. 在过期时间内绑定手机号；
    ...    4. 在过期时间点绑定手机号；
    ...    5. 超过过期时间绑定手机号；
    ...    6. 再次点击重新发送验证码；
    ...    " "1. 成功进入验证码输入界面；
    ...    2. 验证码过期时间设计合理，符合常规（比如15~30分钟）；
    ...    3. 成功绑定；
    ...    4. 成功绑定；
    ...    5. 绑定失败，提示验证码错误。
    ...    6. 能成功重新发送号码，并且进入60秒倒计时。
    ...    "
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element

【N】手机号绑定：检查通知栏信息
    [Documentation]    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入，当前TF卡与SIM未绑定过；
    ...    " "1. 插入与当前TF卡绑定号码不一致的SIM卡；
    ...    2. 重启手机；
    ...    3. 检查手机通知栏信息；
    ...    4. 点击通知栏信息登录成功登录密码卡管家，再次检查通知栏信息；
    ...    5. 点击检查设置按钮；
    ...    " "1. 成功插入；
    ...    2. 成功重启；
    ...    3. 在通知栏显示“密码卡未登录”的提示信息；
    ...    4. 在通知栏上显示“SIM卡已更换，请重新绑定”的提示信息；
    ...    5. 进入绑定手机，输入手机号码界面；
    ...    "
    [Tags]    手机号绑定(#635)
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

【N】手机号绑定：未绑定过的密码卡
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入，当前TF卡是新发的卡，从未进行任何绑定；"
    ...
    ...    操作步骤：
    ...    "1. 插入未绑定过的TF卡和SIM卡；
    ...    2. 重启手机，点击访问并登录被测应用；
    ...    3. 在加密功能异常界面检测到手机卡已更换，点击重新绑定；
    ...    4. 输入正确的手机号码，点击下一步；
    ...    5. 检查验证码是否自动填充；
    ...    6. 点击确定；
    ...    7. 点击完成或者手机返回键；"
    ...
    ...    预期结果：
    ...    "1. 成功插入；
    ...    2. 手机成功重启；密码卡管家成功登录，进入加密功能异常界面；
    ...    3. 成功进入绑定手机界面；
    ...    4. 提示“发送验证码请求中”，进入输入验证码界面；
    ...    5. 手机收到验证码短信，并且验证码自动填充到验证码区域；
    ...    6. 提示手机号码与密码卡成功绑定；
    ...    7. 返回加密功能已启用界面；"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
    Kill Adb Process    ecm

【N】手机号码绑定：修改密码后重新绑定
    [Documentation]    预置条件：
    ...    "1、 WIFI网络连接正常；
    ...    2、 被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    3、手机号码已经开通加密功能。"
    ...
    ...    操作步骤：
    ...    "1. 插入与当前TF卡绑定号码不一致的SIM卡；
    ...    2. 重启手机，点击访问并登录被测应用；
    ...    3. 点击修改密码；
    ...    4. 输入旧口令，点击确定；
    ...    5. 输入新口令，点击下一步；
    ...    6. 再次输入新口令，点击确定；
    ...    7. 点击完成按钮；
    ...    8. 点击重新绑定按钮；
    ...    9. 执行绑定流程；"
    ...
    ...    预期结果：
    ...    "1. 成功插入；
    ...    2. 手机成功重启；密码卡管家成功登录，进入加密功能异常界面；（手机号未绑定）
    ...    3. 成功进入输入旧口令界面；
    ...    4. 成功进入输入新口令界面；
    ...    5. 成功进入再次输入新口令界面；
    ...    6. 密码修改成功，进入修改口令成功界面；
    ...    7. 进入加密功能异常界面（手机号未绑定）；
    ...    8. 成功进入绑定手机界面；
    ...    9. TF卡与SIM卡能成功绑定；"
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
    Kill Adb Process    ecm

【N】手机号码绑定：输入正确的手机号码绑定
    [Documentation]    预置条件：
    ...    "1、被测终端（手机）已经准备就绪；
    ...    2、TF密码卡、SIM卡已经插入；
    ...    3、手机号码已经开通加密功能；
    ...    4、成功进入手机号码绑定界面。"
    ...
    ...    操作步骤：
    ...    "1. 输入正确的手机号码（已经开通加密功能）：当前插入的SIM卡号；
    ...    2. 点击下一步；
    ...    3. 输入服务器发送的验证码，点击确定；"
    ...
    ...    预期结果：
    ...    "1. 成功输入并正确显示；
    ...    2. 成功进入验证码输入界面；输入的手机号码成功收取到服务器发送的验证码；
    ...    3. 手机号码与密码卡成功绑定。
    ...    "
    [Tags]    手机号绑定(#635)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    正在绑定SIM卡...    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Wait Until Page Contains    手机号码绑定成功    30s    check failed!
    Wait Until Page Contains    手机号码与密码卡已绑定    30s    check failed!
    Wait Until Page Contains    可正常使用加密通讯    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/finishButton    30s    check failed!
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    30s    check failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/anquanLayout    30s    check failed!
    sleep    30s
    Close Application
    [Teardown]    Kill Adb Process    ecm

【N】手机号码绑定：绑定流程（移动数据连接环境下绑定)
    [Documentation]    "1、移动数据网络连接正常；
    ...    2、 被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    3、手机号码已经开通加密功能。
    ...    " "1. 插入与当前TF卡绑定号码不一致的SIM卡；
    ...    2. 重启手机，点击访问并登录被测应用；
    ...    3. 在加密功能异常界面检测到手机卡已更换，点击重新绑定；
    ...    4. 输入正确的手机号码，点击下一步；
    ...    5. 检查验证码是否自动填充；
    ...    6. 点击确定；
    ...    7. 点击完成或者手机返回键；
    ...    " "1. 成功插入；
    ...    2. 手机成功重启；密码卡管家成功登录，进入加密功能异常界面；
    ...    3. 成功进入绑定手机界面；
    ...    4. 提示“发送验证码请求中”，进入输入验证码界面；
    ...    5. 手机收到验证码短信，并且验证码自动填充到验证码区域；
    ...    6. 提示手机号码与密码卡成功绑定；
    ...    7. 返回加密功能已启用界面；
    ...    "
    [Tags]    手机号绑定(#635)
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
    Kill Adb Process    ecm

【N】手机号绑定：绑定流程(wifi环境下绑定）
    [Documentation]    "1、 WIFI网络连接正常；
    ...    2、 被测终端（手机）已经准备就绪（已插入TF卡、SIM卡）；
    ...    3、手机号码已经开通加密功能。
    ...    " "1. 插入与当前TF卡绑定号码不一致的SIM卡；
    ...    2. 重启手机，点击访问并登录被测应用；
    ...    3. 在加密功能异常界面检测到手机卡已更换，点击重新绑定；
    ...    4. 输入正确的手机号码，点击下一步；
    ...    5. 检查验证码是否自动填充；
    ...    6. 点击确定；
    ...    7. 点击完成或者手机返回键；
    ...    " "1. 成功插入；
    ...    2. 手机成功重启；密码卡管家成功登录，进入加密功能异常界面；
    ...    3. 成功进入绑定手机界面；
    ...    4. 提示“发送验证码请求中”，进入输入验证码界面；
    ...    5. 手机收到验证码短信，并且验证码自动填充到验证码区域；
    ...    6. 提示手机号码与密码卡成功绑定；
    ...    7. 返回加密功能已启用界面；
    ...    "
    [Tags]    手机号绑定(#635)
    [Setup]    Kill Adb Process    ecm
    ${localAddress}    Get Local Address
    open Application    http://${localAddress}:4723/wd/hub    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    automationName=appium    appPackage=com.cetcs.ecmapplication
    ...    appActivity=.LaunchActivity
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/loginLogo    30s    Failed to jump LoginForm !    #进入安全手机终端，进入密码卡登录界面
    Click Element    id=com.cetcs.ecmapplication:id/rememberLayout
    Input Text    id=com.cetcs.ecmapplication:id/mComplexEditText    ${OldVpwd}
    Click Element    id=com.cetcs.ecmapplication:id/loginBT
    Wait Until Page Contains    加密功能异常    30s    sign in failed!
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/homeErrorButtonTV
    Wait Until Page Contains    请输入开通加密功能的手机号码进行绑定    30s    sign in failed!
    Input Text    id=com.cetcs.ecmapplication:id/phonenumberET    ${TELE_NUMBER}
    click element    id=com.cetcs.ecmapplication:id/mSingleButton
    Wait Until Page Contains    ${TELE_NUMBER}    30s    failed!
    Wait Until Page Contains    30秒后重发    30s    failed!
    Click Element    id=com.cetcs.ecmapplication:id/mSingleButton
    Page Should Contain Text    与在线密管建立连接...
    Wait Until Page Contains Element    id=com.cetcs.ecmapplication:id/bundleSuccessTV    30s    failed!
    Page Should Contain Text    手机号码绑定成功    DEBUG
    Page Should Contain Text    手机号码与密码卡已绑定    DEBUG
    Page Should Contain Text    可正常使用加密通讯    DEBUG
    Click Element    id=com.cetcs.ecmapplication:id/finishButton
    Wait Until Page Contains    加密功能已启用    30s    failed！
    Page Should Contain Text    ${TELE_NUMBER}    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiugaiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/xiaohuiLayout    DEBUG
    Page Should Contain Element    id=com.cetcs.ecmapplication:id/anquanLayout    DEBUG
    sleep    30s
    Close Application
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
