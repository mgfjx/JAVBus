# -*- coding: utf-8 -*-
import os,sys
import subprocess
import time
import json
import webbrowser

try:
    import requests
except:
    print ('\033[31m' + '缺少requests模块，正在安装requests模块，请等待...' + '\033[0m')
    success = os.system('python -m pip install requests')
    if success == 0:
    	print('\033[7;32m' + 'requests模块安装成功.' + '\033[0m')
    	import requests
    else:
    	print ('\033[31m' + 'requests安装失败，请手动在终端执行：\'python -m pip install requests\'重新安装.' + '\033[0m')
    	quit()

#configuration for iOS build setting
CONFIGURATION = "Release"
SDK = "iphoneos"

OpenDownLoadUrl = 1 #打包上传完成后是否使用浏览器打开下载地址: 1 打开， 0 不打开

#configuration for 蒲公英
AlowUploadToPgyer = 1 #值为1表示上传到蒲公英，为0亦然
UPLOAD_URL = "http://www.pgyer.com/apiv1/app/upload"
BASE_URL = "http://www.pgyer.com"
USER_KEY = "3834f11d73cd7d0e419734b68a539bf2" #蒲公英User Key(在账户设置中获取)
API_KEY = "700ffc367a1d86863d40370c3e95da66" #蒲公英API Key
PGY_Description = '' #上传app时的描述信息
PGY_Password = '' #安装应用时的密码

#configuration for fir.im
#上传至fir.im使用的是命令行上传，需要安装fir命令，具体安装请到：https://github.com/FIRHQ/fir-cli/blob/master/README.md
AlowUploadToFir = 0 #值为1表示上传到fir.im，为0亦然
FirIm_BaseUrl = 'http://api.fir.im/apps'
FirIm_API_Token = '2e42187f2685d81c28a87dccc546c2b1'
ChangeLog = 'worinimaa' #更新日志

#上传到蒲公英代码托管,begin-----------------------------------------------------------------------------------------------------------------------------------------------
def uploadToPgyer(ipaPath):

	while not uploadToPgyer_Cmd(ipaPath):
		print ('\033[31m' + '重新上传.....' + '\033[0m')

def uploadToPgyer_Cmd(ipaPath):
	print('\033[31m'+'uploading To 蒲公英....'+'\033[0m')
	cmdStr = 'curl -F "file=@%s" -F "uKey=%s" -F "_api_key=%s" -F "publishRange=3" -F "isPublishToPublic=2" -F "password=%s" -F "updateDescription=%s" -F "enctype=multipart/form-data" %s' % (ipaPath, USER_KEY, API_KEY, PGY_Password, PGY_Description, UPLOAD_URL)
	# print(cmdStr)
	r = os.popen(cmdStr)
	text = r.read()
	r.close();
	if not text == '':
		returnJson = json.loads(text)
		downUrl = BASE_URL + '/' + returnJson['data']['appShortcutUrl']
		downUrl = downUrl.encode('utf8') # 解决python2.7.10编码错误问题
		print('\033[7;32m' + '上传到蒲公英完成,下载地址:%s'%downUrl + '\033[0m')
		if OpenDownLoadUrl == 1:
			webbrowser.open(downUrl.decode('utf8'))
		return True;
	elif text == '':
		print ('\033[5;31m' + '上传到蒲公英失败!' + '\033[0m')
		return False;

def uploadToPgyer_Request(ipaPath):
	with open(ipaPath, 'rb') as f:
		files = {'file': f}
		headers = {'enctype':'multipart/form-data'}
		payload = {'uKey':USER_KEY,'_api_key':API_KEY,'publishRange':'3','isPublishToPublic':'2','password':PGY_Password,'updateDescription':PGY_Description}
		print('\033[31m'+'uploading To 蒲公英....'+'\033[0m')
		try:
			r = requests.post(UPLOAD_URL, data = payload, files = files, headers = headers)
			if r.status_code == requests.codes.ok:
				result = r.json()
				parserReturnData(result)
				return True;
			else:
				print('\033[5;31m' + 'HTTPError,Code:'+r.status_code + '\033[0m')
				return False;
		except :
			print('\033[5;31m' + '请检查网络！' + '\033[0m')
			return False;

#解析上传返回数据
def parserReturnData(jsonResult):
	resultCode = jsonResult['code']
	if resultCode == 0:
		downUrl = BASE_URL + '/' + jsonResult['data']['appShortcutUrl']
		print('\033[7;32m' + '上传到蒲公英完成,下载地址:' + downUrl + '\033[0m')
		if OpenDownLoadUrl == 1:
			webbrowser.open(downUrl)
	else:
		print ('\033[31m' + '上传到蒲公英失败!' + 'Reason:'+jsonResult['message'] + '\033[0m')
		print(jsonResult)

#上传到蒲公英代码托管,end-----------------------------------------------------------------------------------------------------------------------------------------------

#上传到fir.im代码托管,begin-----------------------------------------------------------------------------------------------------------------------------------------------
def uploadToFir(ipaPath):
	uploadToFir_Cmd(ipaPath)
	# uploadToFir_Request(ipaPath)

def uploadToFir_Cmd(ipaPath):
	print('uploadToFir_Cmd')
	uploadCmd = 'fir publish %s --token=%s --changelog=%s' %(ipaPath,FirIm_API_Token,ChangeLog)
	print(uploadCmd)
	print('\033[31m'+'uploading To fir.im....'+'\033[0m')
	isUploaded = os.system(uploadCmd)
	if isUploaded == 0:
		print('\033[7;32m' + '上传到fir.im完成!' + '\033[0m')
	else:
		print ('\033[7;31m' + '上传到fir.im失败!' + '\033[0m')

def uploadToFir_Request(ipaPath):
	print('uploadToFir_Request')

	with open(ipaPath, 'rb') as f:
		param = {'type':'ios', 'bundle_id':'com.xiexiaolong.test', 'api_token':FirIm_API_Token}
		returnData = requests.post(FirIm_BaseUrl, data = param)
		if returnData.status_code == 201:
			jsonDict = returnData.json()
			binary = jsonDict['cert']['binary']

			cmd = 'curl -F "key=%s" -F "token=%s" -F "file=@%s" -F "x:name=%s" -F "x:version=%s" -F "x:build=1" -F "x:release_type=Adhoc" -F "type=ios" -F "x:changelog=%s" %s' % (binary['key'], binary['token'], ipaPath, 'test', '1.0', ChangeLog, binary['upload_url'])
			r = os.popen(cmd)

			# headers = {'Content-Type':'multipart/form-data'}
			# uploadParam = {'key':binary['key'], 'token':binary['token'], 'x:name':'test', 'x:version':'1.0', 'x:build':'1', 'x:release_type':'Adhoc', 'x:changelog':'x:changelog'}
			# print(uploadParam)
			# r = requests.post(binary['upload_url'], data = uploadParam, files = f, headers = headers)
			# print(r.json())


#上传到fir.im代码托管,end-----------------------------------------------------------------------------------------------------------------------------------------------


#编译工程，begin--------------------------------------------------------------------------------------------------------------------------------------------------------
#打包.xcodeproj工程
def buildProject(ProjectName):
	isBuilded = os.system('xcodebuild -project %s.xcodeproj -target %s -configuration Release' % (ProjectName, ProjectName));
	fileName = ProjectName + getNowTime() + '.ipa'
	if isBuilded == 0:
		isPackaged = os.system('xcrun -sdk iphoneos -v PackageApplication ./build/Release-iphoneos/%s.app -o ~/Desktop/%s' % (ProjectName, fileName))	
		if isPackaged == 0:
			ipaPath = os.environ['HOME']
			ipaPath = os.path.join(ipaPath, 'Desktop')
			ipaPath = os.path.join(ipaPath, fileName)
			print('\033[7;32m' + '打包完成,请到%s获取ipa文件'%ipaPath + '\033[0m')
			os.system('rm -rf ./build')
			if AlowUploadToPgyer == 1:
				uploadToPgyer(ipaPath)
			if AlowUploadToFir == 1:
				uploadToFir(ipaPath)

#打包.xcworkspace工程
def buildWorkspace(ProjectName):
	#xcodebuild  -workspace $projectName.xcworkspace -scheme $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
	buildDir = os.path.join(cur_file_dir(),'build')#确保编译输出路径是完整路径编译才不会报错
	buildCmd = 'xcodebuild -workspace %s.xcworkspace -scheme %s -configuration %s CONFIGURATION_BUILD_DIR=%s' % (ProjectName, ProjectName, CONFIGURATION, buildDir)
	isBuilded = os.system(buildCmd);
	fileName = ProjectName + getNowTime() + '.ipa'
	if isBuilded == 0:
		isPackaged = os.system('xcrun -sdk iphoneos -v PackageApplication %s/%s.app -o ~/Desktop/%s' % (buildDir, ProjectName, fileName))	
		if isPackaged == 0:
			ipaPath = os.environ['HOME']
			ipaPath = os.path.join(ipaPath, 'Desktop')
			ipaPath = os.path.join(ipaPath, fileName)
			print('\033[7;32m' + '打包完成,请到%s获取ipa文件'%ipaPath + '\033[0m')
			os.system('rm -rf ./build')
			if AlowUploadToPgyer == 1:
				uploadToPgyer(ipaPath)
			if AlowUploadToFir == 1:
				uploadToFir(ipaPath)
#编译工程，end--------------------------------------------------------------------------------------------------------------------------------------------------------

#获取脚本文件的当前路径
def cur_file_dir():
     #获取脚本路径
     path = sys.path[0]
     #判断为脚本文件还是py2exe编译后的文件，如果是脚本文件，则返回的是脚本的目录，如果是py2exe编译后的文件，则返回的是编译后的文件路径
     if os.path.isdir(path):
         return path
     elif os.path.isfile(path):
         return os.path.dirname(path)

#获取当前时间
def getNowTime():
	return time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))

def main():
	files = []
	path = cur_file_dir()
	print(path)
	files = os.listdir(path)
	options = {'project':'','workspace':'','scheme':'','target':''}
	for name in files:
		if name.endswith('.xcodeproj'):
			options['project'] = str(name)
		elif name.endswith('.xcworkspace'):
			options['workspace'] = name

	# print(options)

	#若果存在workspace，则以workspace打包,否则判断project是否存在，存在即用project打包
	if options['workspace'].strip() != '':
		buildWorkspace(options['workspace'].replace('.xcworkspace', ''))
	elif options['project'].strip() != '':
		buildProject(options['project'].replace('.xcodeproj', ''))
	else:
		print('\033[31m'+'项目不存在,请检查路径(脚本文件需放在被打包的工程目录下)'+'\033[0m')

if __name__ == '__main__':
	main()