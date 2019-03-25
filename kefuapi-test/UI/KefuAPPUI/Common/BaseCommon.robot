*** Settings ***
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Library           json
Resource          ../Variable.robot

*** Keywords ***
Input Object Text
    [Arguments]    ${objectElement}    ${textValue}
    [Documentation]    输入文本信息
    #清空输入框并输入文本
    Clear Text    ${objectElement}
    Input text    ${objectElement}    ${textValue}

Click Object Element
    [Arguments]    ${objectElement}
    [Documentation]    点击按钮
    #多次判断按钮是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Visible    ${objectElement}
    should be true    ${status}    按钮元素在页面没有查看到
    #点击按钮
    click element    ${objectElement}

Repeat Assert Keyword Times
    [Arguments]    ${keyword}    ${element}    ${retrytimes}=${Retrytimes}    ${isPrintLog}=True
    [Documentation]    多次重试执行断言判断，在规定重试次数内成功即断言成功，否则失败，例如：Element Should Be Enabled
    #重试执行断言关键字
    : FOR    ${i}    IN RANGE    ${retrytimes}
    \    ${status}    Run Keyword And Return Status    ${keyword}    ${element}
    \    return from keyword if    ${status}    True
    \    sleep    200ms
    run keyword if    ${isPrintLog}    ${keyword}    ${element}
    return from keyword    False

Get Resource Value
    [Arguments]    ${objectResElement}    ${attributeKey}
    ${objectResJson}    to json    ${objectResElement}
    log    ${objectResJson}
    ${objectValue}    set variable    ${objectResJson['${attributeKey}']['xPath']}
    return from keyword    ${objectValue}

PreInstant Suite Element
    [Documentation]    预加载对应模块的Element变量，转换成json和字典，定义全局变量供测试用例使用
    log    ${SUITE NAME}
    #根据&符号分割用例集名称
    @{words} =    Split String    ${SUITE NAME}    &
    log    ${words[1]}
    #取出自定义的模块名字前缀
    ${resName}    set variable    ${words[1]}
    #将对应取出的element变量转换为json和字典
    ${objectResJson}    to json    ${${words[1]}_ResElement}
    &{objectResDic}    loads    ${${words[1]}_ResElement}
    log    ${objectResDic}
    #设置全局变量供测试用例使用，格式例如：LoginPageResJson、LoginPageResDic
    Set Global Variable    ${${resName}ResJson}    ${objectResJson}
    Set Global Variable    ${${resName}ResDic}    ${objectResDic}

PreInstant Element
    [Arguments]    ${pageName}
    [Documentation]    预加载对应模块的Element变量，转换成json和字典，定义全局变量供测试用例使用
    log    ${pageName}
    #设置指定结构的页面名称，例如：loginPage
    ${objectPage}    set variable    ${pageName}Page
    #将取出的element变量转换为json和字典
    ${objectResJson}    to json    ${${objectPage}_ResElement}
    &{objectResDic}    loads    ${${objectPage}_ResElement}
    log    ${objectResDic}
    #设置全局变量供测试用例使用，格式例如：LoginPageResJson、LoginPageResDic
    Set Global Variable    ${${objectPage}ResJson}    ${objectResJson}
    Set Global Variable    ${${objectPage}ResDic}    ${objectResDic}

PreInstant All Elements
    [Documentation]    预加载对应模块的Element变量，转换成json和字典，定义全局变量供测试用例使用
    log list    ${pageElementModelList}
    #预加载实例所有的element元素变量
    : FOR    ${i}    IN    @{pageElementModelList}
    \    PreInstant Element    ${i}

PreInstant All Elements Resource
    [Documentation]    引入所有模块的Element变量的resource文件
    log list    ${pageElementModelList}
    #预加载实例所有的element元素变量的resource文件
    : FOR    ${i}    IN    @{pageElementModelList}
    \    ${pageModel}    set variable    ${i}Page
    \    Import Resource    ${CURDIR}/../Element/${pageModel}/${pageModel}_Element.robot

Find Element Swipe
    [Arguments]    ${element}
    [Documentation]    多次滑动页面，找到指定元素
    #滑动
    ${width}    Get Window Width
    ${height}    Get Window Height
    ${widthA}    evaluate    ${width}/2
    ${heightA}    evaluate    ${height}/2
    ${offset_x}    evaluate    ${widthA}*3/4
    ${offset_y}    evaluate    ${heightA}*1/4
    #多次滑动
    : FOR    ${i}    IN RANGE    ${Retrytimes}
    \    ${swipeStatus}    Run Keyword And Return Status    Swipe    ${widthA}    ${heightA}    ${widthA}
    \    ...    ${offset_y}
    \    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    return from keyword if    ${status}    True
    \    sleep    1s
    log    滑动滚轮后，页面没有找到指定元素
    Element Should Be Enabled    ${element}
    return from keyword    False

Find Element Swipe With Status
    [Arguments]    ${element}
    [Documentation]    多次滑动页面，找到指定元素
    #滑动
    ${width}    Get Window Width
    ${height}    Get Window Height
    ${widthA}    evaluate    ${width}/2
    ${heightA}    evaluate    1120*13/16
    ${offset_x}    evaluate    ${widthA}*3/4
    ${offset_y}    evaluate    0.5
    #多次滑动
    : FOR    ${i}    IN RANGE    ${Retrytimes}
    \    Swipe    ${widthA}    ${heightA}    ${widthA}    ${offset_y}
    \    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    return from keyword if    ${status}    True
    \    sleep    1s
    log    滑动滚轮后，页面没有找到指定元素
    Element Should Be Enabled    ${element}
    return from keyword    False

Convert Specific String To List
    [Arguments]    ${string}    ${separator}    ${sortBy}=asc
    [Documentation]    根据指定符号进行分割字符串，按照给定的排序方式进行排序后返回列表
    #根据指定符号进行分割字符串，按照给定的排序方式进行排序后返回列表
    @{stringList}    Split String    ${string}    ${separator}
    @{objectList}    create list
    #如果排序需要倒序，则倒序排列列表
    run keyword if    "${sortBy}" == "desc"    Reverse List    ${stringList}
    log list    ${stringList}
    : FOR    ${i}    IN    @{stringList}
    \    append to list    ${objectList}    ${i}
    Return From Keyword    ${objectList}

Get Current PageModel
    [Documentation]    获取当前页面所处的模块名称，例如：Conversation、Queue等
    #获取定义的元素-模块定义数据
    log list    ${pageElementModelList}
    log    ${BasePageResDic}
    #循环获取所有页面模块中所包含的元素与文本
    : FOR    ${i}    IN    @{pageElementModelList}
    \    #判断如果等于Base，则跳进下个循环
    \    Continue For Loop If    "${i}" == "Base"
    \    ${pageElement}    set variable    ${BasePageResDic.${i}.uniqueElement}
    \    ${pageTextName}    set variable    ${BasePageResDic.${i}.uniqueName}
    \    log    ${pageElement}
    \    log    ${pageTextName}
    \    #判断当前页面包含指定元素和文本
    \    ${elementVisibleStatus}    Run Keyword And Return Status    Element Should Be Visible    ${pageElement}
    \    ${elementContainStatus}    Run Keyword And Return Status    Page Should Contain Element    ${pageElement}
    \    ${pageTextStatus}    Run Keyword And Return Status    Page Should Contain Text    ${pageTextName}
    \    return from keyword if    ${elementVisibleStatus} and ${elementContainStatus} and ${pageTextStatus}    ${i}
    return from keyword    false

Find Specific Path With PageModels
    [Arguments]    ${startPageModel}    ${endPageModel}
    [Documentation]    根据指定的两个页面模块找到模块之间的路径
    #定义当前模块和终点模块
    &{BackTrackValitPathDic}    loads    ${BackTrackValitPath}
    ${pageModelKey}    set variable    ${startPageModel}And${endPageModel}    #ConversationAndQueue
    ${modelKey}    set variable    ${pageModelKey}
    @{pageModelKeyList}    Split String    ${pageModelKey}    And
    log list    ${pageModelKeyList}
    #定义正序倒序变量，值为asc、desc
    ${sortBy}    set variable    asc
    #判断在定义模块中是否正序排列存在
    ${status}    Run Keyword And Return Status    Dictionary Should Contain Key    ${BackTrackValitPathDic}    ${pageModelKey}
    run keyword if    ${status}    log    属于正序
    #如果不存在，则倒序排序查一次
    ${oppositekey}    set variable    ${pageModelKeyList[1]}And${pageModelKeyList[0]}
    ${oppsitestatus}    Run Keyword And Return Status    Dictionary Should Contain Key    ${BackTrackValitPathDic}    ${oppositekey}
    run keyword if    ${status}    log    属于倒序，按照倒序进行排列并返回
    run keyword if    ${oppsitestatus}    set suite variable    ${sortBy}    desc
    run keyword if    ${oppsitestatus}    set suite variable    ${modelKey}    ${oppositekey}
    #按照正序或倒序查出path
    @{pathList}    Convert Specific String To List    ${BackTrackValitPathDic.${modelKey}.path}    -    ${sortBy}
    return from keyword    ${pathList}

Enter Specified PageModel
    [Arguments]    ${TestPageModel}=
    [Documentation]    | 一、定义每个页面唯一的标志元素。${BasePage_ResElement}变量中定义了所有模块的模块名称、页面唯一元素、页面唯一文本文案 |
    ...    | 二、根据唯一的标志元素，循环找到属于哪个模块。${BasePage_ResElement}变量中定义了所有模块的模块名称和页面唯一元素，根据查找该模块唯一元素，确定模块名称，例如：Conversation |
    ...    | 三、查询出当前所处的页面，根据当前页面与终点页面，来查询出路径。${BackTrackValitPath}变量中定义了模块与模块之间的路径，例如：Conversation-Avatar-Setting，意思为从Conversation到Avatar再到Setting |
    ...    | 四、循环根据其中路径来确定路程，依次点击到需要的被测的终点页面。从第三步拿到了所有经过的模块路径，依次点击进入到模块即可 |
    #获取当前页面所处的模块名称
    ${currentPageName}    Get Current PageModel
    #根据测试用标签来设置最终页面模块
    log list    ${TEST TAGS}
    #移除默认的kefuappui的标签
    Remove Values From List    ${TEST TAGS}    kefuappui    #去除kefuappui的标签
    #如果未指定页面，则获取用例所在的模块标签
    ${testTag}    set variable    ${TEST TAGS[0]}
    Run Keyword If    "${TestPageModel}" == "${EMPTY}"    set suite variable    ${TestPageModel}    ${testTag}
    #如果发现当前所处页面和跳转页面一致，则不处理跳转逻辑
    return from keyword if    "${currentPageName}" == "${TestPageModel}"    log    目前处于所需要测试的页面，无需后续跳转
    #判断当前页面未找到所匹配的页面模块信息
    Run Keyword If    "false" == "${currentPageName}"    FAIL    当前页面未找到所匹配的页面模块信息，请查验可能有遗漏页面模块未定义
    #根据指定的两个页面模块找到模块之间的路径
    @{pathList}    Find Specific Path With PageModels    ${currentPageName}    ${TestPageModel}
    log list    ${pathList}
    Remove From List    ${pathList}    0
    log list    ${pathList}
    #循环点击路径
    : FOR    ${i}    IN    @{pathList}
    \    log    ${BasePageResDic.${i}.${i}Element}
    \    Click Object Element    ${BasePageResDic.${i}.${i}Element}
