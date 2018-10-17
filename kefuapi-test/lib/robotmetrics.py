#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding("utf-8")
from bs4 import BeautifulSoup
import sys
import os
import math
from datetime import datetime
from datetime import timedelta
from robot.api import ExecutionResult, ResultVisitor
import smtplib 
from email.mime.multipart import MIMEMultipart 
from email.mime.text import MIMEText 
from email.mime.base import MIMEBase 
from email import encoders 
import time


# ======================== START OF CUSTOMIZE REPORT ================================== #

# URL or filepath of your company logo
logo = "http://kefu.easemob.com/images/auth/logo.png"

# Ignores following library keywords in metrics report
ignore_library = [
    'BuiltIn',
    'SeleniumLibrary',
    'String',
    'Collections',
    'DateTime',
    ]

# Ignores following type keywords in metrics report
ignore_type = [
    'foritem',
    'for',
    ]


# ======================== END OF CUSTOMIZE REPORT ================================== #

# Report to support file location as arguments
# Source Code Contributed By : Ruud Prijs
def getopts(argv):
        opts = {}
        while argv:
            if argv[0][0] == '-':
                if argv[0] in opts:
                    opts[argv[0]].append(argv[1])
                else:
                    opts[argv[0]] = [argv[1]]
            argv = argv[1:]
        return opts

myargs = getopts(sys.argv)

# input directory
if '-inputpath' in myargs:
    path = os.path.abspath(os.path.expanduser(myargs['-inputpath'][0]))
else:
    path = os.path.curdir

# report.html file
if '-report' in myargs:
    report_name = myargs['-report'][0]
else:
    report_name = 'report.html'

# log.html file
if '-log' in myargs:
    log_name = myargs['-log'][0]
else:
    log_name = 'log.html'

# output.xml file
if '-output' in myargs:
    output_name = os.path.join(path,myargs['-output'][0])
else:
    output_name = os.path.join(path,'output.xml')

# reveiver email
if '-receiver' in myargs:
    receiver_name = myargs['-receiver'][0]
else:
    receiver_name = 'Robot'
    
# collection log name
if '-collectionLogName' in myargs:
    collection_log_name = myargs['-collectionLogName'][0]
else:
    collection_log_name = 'emailreport.html'

print receiver_name
print collection_log_name

mtTime = datetime.now().strftime('%Y%m%d-%H%M%S')
# Output result file location
# result_file_name = 'metrics-'+ mtTime + '.html'
result_file_name = 'metrics'+ '.html'
result_file = os.path.join(path,result_file_name)

# Read output.xml file
result = ExecutionResult(output_name)
result.configure(stat_config={'suite_stat_level': 2,
                              'tag_stat_combine': 'tagANDanother'})

head_content = """
<!doctype html>
<html lang="en">

<head>
    <link rel="shortcut icon" href="https://png.icons8.com/windows/50/000000/bot.png" type="image/x-icon" />
    <title>RF Metrics Report</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="http://lijipeng.top/rest/autotest/css/bootstrap.css" rel="stylesheet"/>
    <link href="http://lijipeng.top/rest/autotest/css/dataTables.bootstrap4.min.css" rel="stylesheet"/>

    <link href="http://lijipeng.top/rest/autotest/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="http://lijipeng.top/rest/autotest/css/font-awesome.min.css" rel="stylesheet">
    <link href="http://lijipeng.top/rest/autotest/css/tooltip.css" rel="stylesheet">
    <link href="http://lijipeng.top/rest/autotest/css/util.css" rel="stylesheet">
    
   <script src="http://lijipeng.top/rest/autotest/metrics/jquery-3.3.1.js" type="text/javascript">
   </script>

     <!-- Bootstrap core JavaScript
    ================================================== -->
   <!-- Placed at the end of the document so the pages load faster -->
   <script crossorigin="anonymous" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" src="http://lijipeng.top/rest/autotest/metrics/jquery-3.3.1.slim.min.js">
   </script>
   <script crossorigin="anonymous" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" src="http://lijipeng.top/rest/autotest/metrics/popper.min.js">
   </script>
   <script crossorigin="anonymous" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" src="http://lijipeng.top/rest/autotest/metrics/bootstrap.min.js">
   </script>
    <!-- Bootstrap core Googleccharts
    ================================================== -->
   <script src="http://lijipeng.top/rest/autotest/metrics/loader.js" type="text/javascript">
   </script>
   <script type="text/javascript">
    google.charts.load('current', {packages: ['corechart']});
   </script>
   <!-- Bootstrap core Datatable
    ================================================== -->

    <script src="http://lijipeng.top/rest/autotest/metrics/jquery-3.3.1.js" type="text/javascript"></script>
    <script src="http://lijipeng.top/rest/autotest/metrics/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="http://lijipeng.top/rest/autotest/metrics/dataTables.bootstrap4.min.js" type="text/javascript"></script>
    
    <!-- 侧边栏引入的相关文件 -->
    <link rel="stylesheet" type="text/css" href="http://lijipeng.top/rest/autotest/main.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <!--<script type="text/javascript" src="http://lijipeng.top/rest/js/jquery-1.12.1.min.js"></script>-->
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <!--<script type="text/javascript" src="http://lijipeng.top/rest/js/bootstrap.js"></script>-->
    <script type="text/javascript" src="http://lijipeng.top/rest/autotest/script.js"></script>
    <script type="text/javascript" src='http://kefu.easemob.com/webim/easemob.js'></script>
    <script type="text/javascript" src="http://lijipeng.top/rest/autotest/hp.js" ></script>

    <style>        
        .sidebar {
          position: fixed;
          top: 0;
          bottom: 0;
          left: 0;
          z-index: 100; /* Behind the navbar */
          box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
        }
        
        .sidebar-sticky {
          position: relative;
          top: 0;
          height: calc(100vh - 48px);
          padding-top: .5rem;
          overflow-x: hidden;
          overflow-y: auto; /* Scrollable contents if viewport is shorter than content. */
        }
        
        @supports ((position: -webkit-sticky) or (position: sticky)) {
          .sidebar-sticky {
            position: -webkit-sticky;
            position: sticky;
          }
        }
        
        .sidebar .nav-link {
          color: black;
        }
        
        .sidebar .nav-link.active {
          color: #007bff;
        }
        
        .sidebar .nav-link:hover .feather,
        .sidebar .nav-link.active .feather {
          color: inherit;
        }

        [role="main"] {
          padding-top: 8px;
        }
        
		/* Set height of body and the document to 100% */
		body {
			height: 100%;
			margin: 0;
			//font-family:  Comic Sans MS;
			background-color: white;
		}

		/* Style tab links */
		.tablinkLog {
			cursor: pointer;
		}
		
        @import url(https://fonts.googleapis.com/css?family=Droid+Sans);
		.loader {
			position: fixed;
			left: 0px;
			top: 0px;
			width: 100%;
			height: 100%;
			z-index: 9999;
			background: url('http://www.downgraf.com/wp-content/uploads/2014/09/01-progress.gif?e44397') 50% 50% no-repeat rgb(249,249,249);
		}

		/* TILES */
		.tile {
		  width: 100%;
		  float: left;
		  margin: 0px;
		  color: black;
		  -moz-border-radius: 5px;
		  -webkit-border-radius: 15px;
		  margin-bottom: 0px;
		  position: relative;
		  color: white!important;
		}

		.tile.tile-fail {
		  background: #212F3D!important;
		}
		.tile.tile-pass {
		  background: #117864!important;
		}
		.tile.tile-info {
		  background: #1A5276!important;
		}

        .sm-data-box-1 .cus-sat-stat {
            font-size: 42px;
        }

        .weight-500 {
            font-weight: 500 !important;
        }

        .block {
            display: block !important;
        }

        .text-center {
            text-align: center;
        }

       .mt-8 {
        margin-top: 8px !important;
        }

        .mt-5 {
        margin-top: 5px !important;
        }

        /*Small graph*/
        .flex-stat {
        overflow: hidden;
        }

        .flex-stat li {
        float: left;
        width: 33.33%;
        text-align: center;
        }

        .flex-stat li > span {
        text-transform: capitalize;
        }

        .font-14 {
        font-size: 14px !important;
        }

        .font-15 {
        font-size: 15px !important;
        }

        ul {
        list-style: none;
        }

    </style>
</head>
"""

soup = BeautifulSoup(head_content,"html.parser")

body = soup.new_tag('body')
soup.insert(20, body)

icons_txt= """
<div class="loader"></div>
 <div class="container-fluid">
        <div class="row">
            <nav class="col-md-2 d-none d-md-block bg-light sidebar" style="font-size:16px;">
                <div class="sidebar-sticky">
                    <ul class="nav flex-column">                            
                  <img src="%s" style="height:15vh!important;border-radius:50%%;margin: 10px 0px 0px 37px;width:50%%;"/>
                
				<br>
				
				<h6 class="sidebar-heading d-flex justify-content-between align-items-center text-muted">
                        <span>Metrics</span>
                        <a class="d-flex align-items-center text-muted" href="#"></a>
                    </h6>

                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" id="defaultOpen" onclick="openPage('dashboard', this, 'orange')">
								<i class="fa fa-dashboard"></i> 首页
							</a>
                        </li>
                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" onclick="openPage('collectionLog', this, 'orange');">
                              <i class="fa fa-wpforms"></i> 汇总日志
                            </a>
                        </li>  
                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" onclick="openPage('log', this, 'orange');">
                              <i class="fa fa-wpforms"></i> RF 原生日志
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" onclick="openPage('testMetrics', this, 'orange');executeDataTable('#tm',5)">
                              <i class="fa fa-list-alt"></i> 测试用例日志
                            </a>
                        </li>                    
                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" onclick="openPage('suiteMetrics', this, 'orange');executeDataTable('#sm',4)" >
								<i class="fa fa-th-large"></i> 测试用例集日志
							</a>
                        </li>
                        <li class="nav-item">
                            <a class="tablink nav-link" href="#" onclick="openPage('keywordMetrics', this, 'orange');executeDataTable('#km',5)">
							  <i class="fa fa-table"></i> 关键字日志
							</a>
                        </li>
                    </ul>
					<h6 class="sidebar-heading d-flex justify-content-between align-items-center text-muted">
                        <span>Project</span>
                        <a class="d-flex align-items-center text-muted" href="#"></a>
                    </h6>
                    <ul class="nav flex-column mb-2">
                        <li class="nav-item">
                            <a style="color:blue;" class="tablink nav-link" target="_blank" href="http://c1.private.easemob.com/pages/viewpage.action?pageId=3847479">
							  <i class="fa fa-external-link"></i> 教程文档
							</a>
                        </li>
						<li class="nav-item">
                            <a style="color:blue;" class="tablink nav-link" target="_blank" href="http://j1.private.easemob.com/secure/Dashboard.jspa">
							  <i class="fa fa-external-link"></i> JIRA
							</a>
                        </li>
						<li class="nav-item">
                            <a style="color:blue;" class="tablink nav-link" target="_blank" href="http://c1.private.easemob.com/pages/viewpage.action?pageId=886528">
							  <i class="fa fa-external-link"></i> QA TEAM
							</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
"""%(logo)

body.append(BeautifulSoup(icons_txt, 'html.parser'))


page_content_div = soup.new_tag('div')
page_content_div["role"] = "main"
page_content_div["class"] = "col-md-9 ml-sm-auto col-lg-10 px-4"
body.insert(50, page_content_div)

### ============================ START OF DASHBOARD ======================================= ####
total_suite = 0
passed_suite = 0
failed_suite = 0

class SuiteResults(ResultVisitor):
    
    def start_suite(self,suite):
       
        suite_test_list = suite.tests
        if not suite_test_list:
            pass
        else:        
            global total_suite
            total_suite+= 1
            if suite.status== "PASS":
                global passed_suite
                passed_suite+= 1
            else:
                global failed_suite
                failed_suite += 1

result.visit(SuiteResults())

suitepp = math.ceil(passed_suite*100.0/total_suite)

elapsedtime = datetime(1970, 1, 1) + timedelta(milliseconds=result.suite.elapsedtime)
elapsedtime = elapsedtime.strftime("%X")

myResult = result.generated_by_robot

if myResult:
	generator = "Robot"
else:
	generator = "Rebot"
	
stats = result.statistics
total= stats.total.all.total
passed= stats.total.all.passed
failed= stats.total.all.failed

testpp = round(passed*100.0/total,2)

total_keywords = 0
passed_keywords = 0
failed_keywords = 0

class KeywordResults(ResultVisitor):
    
    def start_keyword(self,kw):
        # Ignore library keywords
        keyword_library = kw.libname

        if any (library in keyword_library for library in ignore_library):
            pass
        else:
            keyword_type = kw.type            
            if any (library in keyword_type for library in ignore_type):
                pass
            else:
                global total_keywords
                total_keywords+= 1
                if kw.status== "PASS":
                    global passed_keywords
                    passed_keywords+= 1
                else:
                    global failed_keywords
                    failed_keywords += 1

result.visit(KeywordResults())

kwpp = round(passed_keywords*100.0/total_keywords,2)

dashboard_content="""
<div class="tabcontent" id="dashboard">
			
				<div class="d-flex flex-column flex-md-row align-items-center p-1 mb-3 bg-light border-bottom shadow-sm">
				  <h5 class="my-0 mr-md-auto font-weight-normal"><i class="fa fa-dashboard"></i> 首页</h5>
				  <nav class="my-2 my-md-0 mr-md-3" style="color:red">
					<a class="p-2"><b style="color:black;">用时: </b>%s h</a>
					<a class="p-2"><b style="color:black;cursor: pointer;" data-toggle="tooltip" title=".xml file is created by">执行人: </b>%s</a>
				  </nav>                  
				</div>

                <div class="row">

                <div class="col-md-4" onclick="openPage('suiteMetrics', this, '')" data-toggle="tooltip" title="Click to view Suite metrics" style="cursor: pointer;">
                    <div class="panel-body sm-data-box-1 tile tile-fail">
                        <span class="weight-500 block text-center txt-dark mt-8">SUITE STATISTICS</span>	
                        <div class="cus-sat-stat weight-500 txt-success text-center mt-5">
                            <span>%s</span><span style="font-size:15px">%%</span>
                        </div>
                        <ul class="flex-stat mt-5">
                            <li>
                                <span class="block">Total</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Pass</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Fail</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-4" onclick="openPage('testMetrics', this, '')" data-toggle="tooltip" title="Click to view Test metrics" style="cursor: pointer;">
                    <div class="panel-body sm-data-box-1  tile tile-pass">
                        <span class="weight-500 block text-center txt-dark mt-8">TEST STATISTICS</span>
                        <div class="cus-sat-stat weight-500 txt-success text-center mt-5">
                            <span>%s</span><span style="font-size:15px">%%</span>
                        </div>
                        <ul class="flex-stat mt-5">
                            <li>
                                <span class="block">Total</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Pass</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Fail</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-4" onclick="openPage('keywordMetrics', this, '')" data-toggle="tooltip" title="Click to view Keyword metrics" style="cursor: pointer;">
                    <div class="panel-body sm-data-box-1  tile tile-info">
                        <span class="weight-500 block text-center txt-dark mt-8">KEYWORD STATISTICS</span>	
                        <div class="cus-sat-stat weight-500 txt-success text-center mt-5">
                            <span>%s</span><span style="font-size:15px">%%</span>
                        </div>
                        <ul class="flex-stat mt-5">
                            <li>
                                <span class="block">Total</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Pass</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                            <li>
                                <span class="block">Fail</span>
                                <span class="block txt-dark weight-500 font-15">%s</span>
                            </li>
                        </ul>
                    </div>
                </div>

                </div>
				
				
				<hr></hr>
				<div class="row">
					<div class="col-md-12" style="background-color:white;height:450px;width:auto;border:groove;">
						<span style="font-weight:bold">Top 10 测试用例集(sec):</span>
                        <div id="suiteBarID" style="height:400px;width:auto;"></div>
					</div>
					<div class="col-md-12" style="background-color:white;height:450px;width:auto;border:groove;">
						<span style="font-weight:bold">Top 10 测试用例(sec):</span>
                        <div id="testsBarID" style="height:400px;width:auto;"></div>
					</div>
					<div class="col-md-12" style="background-color:white;height:450px;width:auto;border:groove;">
						<span style="font-weight:bold">Top 10 关键字(sec):</span>
                        <div id="keywordsBarID" style="height:400px;width:auto;"></div>
					</div>
				</div>
				<div class="row">
				<div class="col-md-12" style="height:25px;width:auto;">
					<p class="text-muted" style="text-align:center;font-size:9px">@Robotframework Metrics Report</p>
				</div>
				</div>
   
   <script>
    window.onload = function(){
    executeDataTable('#sm',5);
    executeDataTable('#tm',3);
    executeDataTable('#km',3);    
    createBarGraph('#sm',0,5,10,'suiteBarID','用时(s): ','Suite');    
    createBarGraph('#tm',1,3,10,'testsBarID','用时(s): ','Test');    
    createBarGraph('#km',1,3,10,'keywordsBarID','用时(s): ','Keyword');
	};
   </script>
   <script>
function openInNewTab(url,element_id) {
  var element_id= element_id;
  var win = window.open(url, '_blank');
  win.focus();
  $('body').scrollTo(element_id); 
}
</script>
  </div>
""" % (elapsedtime,receiver_name,suitepp,total_suite,passed_suite,failed_suite,testpp,total,passed,failed,kwpp,total_keywords,passed_keywords,failed_keywords)
page_content_div.append(BeautifulSoup(dashboard_content, 'html.parser'))

### ============================ END OF DASHBOARD ============================================ ####

### ============================ START OF SUITE METRICS ======================================= ####

# Tests div
suite_div = soup.new_tag('div')
suite_div["id"] = "suiteMetrics"
suite_div["class"] = "tabcontent"
page_content_div.insert(50, suite_div)

test_icon_txt="""
<h4><b><i class="fa fa-table"></i> 测试用例集日志</b></h4>
<hr></hr>
"""
suite_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))

# Create table tag
table = soup.new_tag('table')
table["id"] = "sm"
table["class"] = "table table-striped table-bordered"
suite_div.insert(10, table)

thead = soup.new_tag('thead')
table.insert(0, thead)

tr = soup.new_tag('tr')
thead.insert(0, tr)

th = soup.new_tag('th')
th.string = "Suite Name"
tr.insert(0, th)

th = soup.new_tag('th')
th.string = "Status"
tr.insert(1, th)

th = soup.new_tag('th')
th.string = "Total"
tr.insert(2, th)

th = soup.new_tag('th')
th.string = "Pass"
tr.insert(3, th)

th = soup.new_tag('th')
th.string = "Fail"
tr.insert(4, th)

th = soup.new_tag('th')
th.string = "Elapsed (s)"
tr.insert(5, th)

tbody = soup.new_tag('tbody')
table.insert(11, tbody)

### =============== GET SUITE METRICS =============== ###

class SuiteResults(ResultVisitor):

    def start_suite(self, suite):

        suite_test_list = suite.tests
        if not suite_test_list:
            pass
        else:
            stats = suite.statistics
            table_tr = soup.new_tag('tr')
            tbody.insert(0, table_tr)

            table_td = soup.new_tag('td',style="word-wrap: break-word;max-width: 250px; white-space: normal;cursor: pointer; text-decoration: underline; color:blue")
            table_td.string = str(suite)
            table_td['onclick']="openInNewTab('%s%s%s','%s%s')"%(log_name,'#',suite.id,'#',suite.id)
            table_td['data-toggle']="tooltip"
            table_td['title']="Click to view '%s' logs"% suite
            table_tr.insert(0, table_td)

            table_td = soup.new_tag('td')
            table_td.string = str(suite.status)
            table_tr.insert(1, table_td)

            table_td = soup.new_tag('td')
            table_td.string = str(stats.all.total)
            table_tr.insert(2, table_td)

            table_td = soup.new_tag('td')
            table_td.string = str(stats.all.passed)
            table_tr.insert(3, table_td)

            table_td = soup.new_tag('td')
            table_td.string = str(stats.all.failed)
            table_tr.insert(4, table_td)

            table_td = soup.new_tag('td')
            table_td.string = str(suite.elapsedtime/float(1000))
            table_tr.insert(5, table_td)

result.visit(SuiteResults())
test_icon_txt="""
<div class="row">
<div class="col-md-12" style="height:25px;width:auto;">
</div>
</div>
"""
suite_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))
### ============================ END OF SUITE METRICS ============================================ ####


### ============================ START OF TEST METRICS ======================================= ####
# Tests div
tm_div = soup.new_tag('div')
tm_div["id"] = "testMetrics"
tm_div["class"] = "tabcontent"
page_content_div.insert(100, tm_div)

test_icon_txt="""
<h4><b><i class="fa fa-table"></i> 测试用例日志</b></h4>
<hr></hr>
"""
tm_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))

# Create table tag
table = soup.new_tag('table')
table["id"] = "tm"
table["class"] = "table table-striped table-bordered"
tm_div.insert(10, table)

thead = soup.new_tag('thead')
table.insert(0, thead)

tr = soup.new_tag('tr')
thead.insert(0, tr)

th = soup.new_tag('th')
th.string = "Suite Name"
tr.insert(0, th)

th = soup.new_tag('th')
th.string = "Test Case"
tr.insert(1, th)

th = soup.new_tag('th')
th.string = "Status"
tr.insert(2, th)

th = soup.new_tag('th')
th.string = "Elapsed (s)"
tr.insert(3, th)

tbody = soup.new_tag('tbody')
table.insert(11, tbody)

### =============== GET TEST METRICS =============== ###

class TestCaseResults(ResultVisitor):

    def visit_test(self, test):

        table_tr = soup.new_tag('tr')
        tbody.insert(0, table_tr)

        table_td = soup.new_tag('td',style="word-wrap: break-word;max-width: 200px; white-space: normal")
        table_td.string = str(test.parent)
        table_tr.insert(0, table_td)

        table_td = soup.new_tag('td',style="word-wrap: break-word;max-width: 250px; white-space: normal;cursor: pointer; text-decoration: underline; color:blue")
        table_td.string = str(test)
        table_td['onclick']="openInNewTab('%s%s%s','%s%s')"%(log_name,'#',test.id,'#',test.id)
        table_td['data-toggle']="tooltip"
        table_td['title']="Click to view '%s' logs"% test
        table_tr.insert(1, table_td)

        table_td = soup.new_tag('td')
        table_td.string = str(test.status)
        table_tr.insert(2, table_td)

        table_td = soup.new_tag('td')
        table_td.string = str(test.elapsedtime/float(1000))
        table_tr.insert(3, table_td)

result.visit(TestCaseResults())

test_icon_txt="""
<div class="row">
<div class="col-md-12" style="height:25px;width:auto;">
</div>
</div>
"""
tm_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))
### ============================ END OF TEST METRICS ============================================ ####

### ============================ START OF KEYWORD METRICS ======================================= ####

# Keywords div
km_div = soup.new_tag('div')
km_div["id"] = "keywordMetrics"
km_div["class"] = "tabcontent"
page_content_div.insert(150, km_div)

keyword_icon_txt="""
<h4><b><i class="fa fa-table"></i> 关键字日志</b></h4>
  <hr></hr>
"""
km_div.append(BeautifulSoup(keyword_icon_txt, 'html.parser'))

# Create table tag
# <table id="myTable">
table = soup.new_tag('table')
table["id"] = "km"
table["class"] = "table table-striped table-bordered"
km_div.insert(10, table)

thead = soup.new_tag('thead')
table.insert(0, thead)

tr = soup.new_tag('tr')
thead.insert(0, tr)

th = soup.new_tag('th')
th.string = "Test Case"
tr.insert(1, th)

th = soup.new_tag('th')
th.string = "Keyword"
tr.insert(1, th)

th = soup.new_tag('th')
th.string = "Status"
tr.insert(2, th)

th = soup.new_tag('th')
th.string = "Elapsed (s)"
tr.insert(3, th)

tbody = soup.new_tag('tbody')
table.insert(1, tbody)

class KeywordResults(ResultVisitor):

    def __init__(self):
        self.test = None

    def start_test(self, test):
        self.test = test

    def end_test(self, test):
        self.test = None

    def start_keyword(self,kw):
        # Get test case name (Credits: Robotframework author - Pekke)
        test_name = self.test.name if self.test is not None else ''

         # Ignore library keywords
        keyword_library = kw.libname

        if any (library in keyword_library for library in ignore_library):
            pass
        else:
            keyword_type = kw.type            
            if any (library in keyword_type for library in ignore_type):
                pass
            else:
                table_tr = soup.new_tag('tr')
                tbody.insert(1, table_tr)

                table_td = soup.new_tag('td',style="word-wrap: break-word;max-width: 250px; white-space: normal")
                
                if keyword_type != "kw":
                    table_td.string = str(kw.parent)
                else:
                    table_td.string = str(test_name)
                table_tr.insert(0, table_td)

                table_td = soup.new_tag('td',style="word-wrap: break-word;max-width: 250px; white-space: normal")
                table_td.string = str(kw.kwname)
                table_tr.insert(1, table_td)

                table_td = soup.new_tag('td')
                table_td.string = str(kw.status)
                table_tr.insert(2, table_td)

                table_td = soup.new_tag('td')
                table_td.string =str(kw.elapsedtime/float(1000))
                table_tr.insert(3, table_td)

result.visit(KeywordResults())
test_icon_txt="""
<div class="row">
<div class="col-md-12" style="height:25px;width:auto;">
</div>
</div>
"""
km_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))
### ============================ END OF KEYWORD METRICS ======================================= ####


### ============================ START OF LOGS ====================================== ###

# Logs div
log_div = soup.new_tag('div')
log_div["id"] = "log"
log_div["class"] = "tabcontent"
page_content_div.insert(200, log_div)

test_icon_txt="""
    <p style="text-align:right">** <b>Report.html</b> 和 <b>Log.html</b> 需要和metrics.html在一个文件夹下</p>
  <div class="embed-responsive embed-responsive-4by3">
    <iframe class="embed-responsive-item" src=%s></iframe>
  </div>
"""%(log_name)
log_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))

### ============================ END OF LOGS ======================================= ####

### ============================ START OF LOGS ====================================== ###

# Logs div
log_div = soup.new_tag('div')
log_div["id"] = "collectionLog"
log_div["class"] = "tabcontent"
page_content_div.insert(200, log_div)

test_icon_txt="""
    <p style="text-align:right">** <b>%s</b> 需要和metrics.html在一个文件夹下</p>
  <div class="embed-responsive embed-responsive-4by3">
    <iframe class="embed-responsive-item" src=%s></iframe>
  </div>
"""%(collection_log_name,collection_log_name)
log_div.append(BeautifulSoup(test_icon_txt, 'html.parser'))

### ============================ END OF LOGS ======================================= ####


script_text="""

    <script>
        (function () {
        var textFile = null,
          makeTextFile = function (text) {
            var data = new Blob([text], {type: 'text/plain'});
            if (textFile !== null) {
              window.URL.revokeObjectURL(textFile);
            }
            textFile = window.URL.createObjectURL(data);
            return textFile;
          };
        
          var create = document.getElementById('create'),
            textbox = document.getElementById('textbox');
          create.addEventListener('click', function () {
            var link = document.getElementById('downloadlink');
            link.href = makeTextFile(textbox.value);
            link.style.display = 'block';
          }, false);
        })();
    </script>
    <script>
       function createBarGraph(tableID,keyword_column,time_column,limit,ChartID,Label,type){
		var status = [];
		css_selector_locator = tableID + ' tbody >tr'
		var rows = $(css_selector_locator);
		var columns;
		var myColors = [
			'#4F81BC',
            '#C0504E',
            '#9BBB58',
            '#24BEAA',
            '#8064A1',
            '#4AACC5',
            '#F79647',
            '#815E86',
            '#76A032',
            '#34558B'
		];
		status.push([type, Label,{ role: 'annotation'}, {role: 'style'}]);
		for (var i = 0; i < rows.length; i++) {
			if (i == Number(limit)){
				break;
			}
			//status = [];
			name_value = $(rows[i]).find('td'); 
		  
			time=($(name_value[Number(time_column)]).html()).trim();
			keyword=($(name_value[Number(keyword_column)]).html()).trim();
			status.push([keyword,parseFloat(time),parseFloat(time),myColors[i]]);
		  }
		  var data = google.visualization.arrayToDataTable(status);

		  var options = {
            legend: 'none',
            chartArea: {width: "92%",height: "75%"},
            bar: {
                groupWidth: '90%'
            },
			annotations: {
				alwaysOutside: true,
                textStyle: {
                fontName: 'Comic Sans MS',
                fontSize: 13,
                bold: true,
                italic: true,
                color: "black",     // The color of the text.
                },
			},
            hAxis: {
                textStyle: {
                    fontName: 'Arial',
                    fontSize: 10,
                }
            },
            vAxis: {
                gridlines: { count: 10 },
                textStyle: {                    
                    fontName: 'Comic Sans MS',
                    fontSize: 10,
                }
            },
		  };  

            // Instantiate and draw the chart.
            var chart = new google.visualization.ColumnChart(document.getElementById(ChartID));
            chart.draw(data, options);
         }

    </script>

 <script>
  function executeDataTable(tabname,sortCol) {
    $(tabname).DataTable(
        {
        retrieve: true,
        "order": [[ Number(sortCol), "desc" ]]
        } 
    );
}
 </script>
 <script>
  function openPage(pageName,elmnt,color) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].style.backgroundColor = "";
    }
    document.getElementById(pageName).style.display = "block";
    elmnt.style.backgroundColor = color;

}
// Get the element with id="defaultOpen" and click on it
document.getElementById("defaultOpen").click();
 </script>
 <script>
 // Get the element with id="defaultOpen" and click on it
document.getElementById("defaultOpen").click();
 </script>
 <script>
$(window).on('load',function(){$('.loader').fadeOut();});
</script>
"""

body.append(BeautifulSoup(script_text, 'html.parser'))

### ====== START TO 侧边栏 ===== ###

cebianlan= """
         <ul class="cbl" >
            <li><a href="http://wpa.qq.com/msgrd?v=3&uin=260553619&site=qq&menu=yes">
                <div class="icon d1"><i class="i1"></i><span class="title">在线QQ</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="#">
                <div class="icon d2"><i class="i2"></i><span class="title">18612390240</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="http://c1.private.easemob.com/pages/viewpage.action?pageId=3847479" target='_blank'">
                <div class="icon"><i class="i3"></i><span class="title">配置文档</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="javascript:;" class="im-biz">
                <div class="icon d5"><i class="i5"></i><span class="title">在线客服</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="javascript:;" class="back-top" id="back-top">
                <div class="icon d4"><i class="i6"></i><span class="title">回到顶部</span></div>
            </a></li>
        
        </ul>

"""

body.append(BeautifulSoup(cebianlan, 'html.parser'))

### ====== END TO 侧边栏 ===== ###

### ====== WRITE TO RF_METRICS_REPORT.HTML ===== ###

# Write output as html file
with open(result_file, 'w') as outfile:
    outfile.write(soup.prettify())

# Wait for 2 seconds - File is generated
time.sleep(2)


# ==== END OF EMAIL CONTENT ====== #