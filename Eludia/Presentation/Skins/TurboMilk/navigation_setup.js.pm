// Setup eludia application javascript file

var app_title = '';
var app_code = '';
var app_url = '';

function _get_HTA_dir() {
	return __get_env_var('ProgramFiles')+'\\'+app_code;
}


function _get_HTA_fname() {
	return _get_HTA_dir()+'\\'+app_code+'.hta';
}


function _guess_app_url() {
	var _url = self.location.protocol+'//'+self.location.hostname;
	if( self.location.port )
		_url = _url+':'+self.location.port;

	return _url;
}


function _install_HTA( FSO, HTA_content ) {
	var filename_HTA = _get_HTA_fname();
	var dirname_HTA = _get_HTA_dir();

	if( !FSO.FolderExists(dirname_HTA) )
		FSO.CreateFolder(dirname_HTA);

	if( FSO.FileExists(filename_HTA) )
		FSO.DeleteFile(filename_HTA);

	_create_HTA_file( FSO, HTA_content );
	_create_shortcut();

	alert('���������� "'+app_title+'" �����������.');
}


function _create_HTA_file( FSO, HTA_content ) {

	var fh = FSO.OpenTextFile(_get_HTA_fname(), 2, true);
	fh.Write(HTA_content);
	fh.Close();
}


function _create_shortcut() {
	var Shell = new ActiveXObject("WScript.Shell");
	var DesktopPath = Shell.SpecialFolders("Desktop");
	var link = Shell.CreateShortcut(DesktopPath+'\\'+app_title+ ".lnk");
	link.Description = app_title;
	//link.HotKey = "CTRL+ALT+SHIFT+X";
	link.IconLocation = app_url+'/favicon.ico';
	link.TargetPath = _get_HTA_fname();
	link.WindowStyle = 4;
	link.WorkingDirectory = _get_HTA_dir();
	link.Save();

	var QuickLaunchPath = __get_env_var('APPDATA')+'\\Microsoft\\Internet Explorer\\Quick Launch';
	var link = Shell.CreateShortcut(QuickLaunchPath+'\\'+app_title+ ".lnk");
	link.Description = app_title;
	//link.HotKey = "CTRL+ALT+SHIFT+X";
	link.IconLocation = app_url+'/favicon.ico';
	link.TargetPath = _get_HTA_fname();
	link.WindowStyle = 4;
	link.WorkingDirectory = _get_HTA_dir();
	link.Save();
}


function __get_env_var( varname ) {
	var WshShell = new ActiveXObject("WScript.Shell");
	return WshShell.ExpandEnvironmentStrings('%'+varname+'%');
}


function SetupHTA(app_codevar, app_titlevar, app_urlvar, HTA_content) {
	app_code = app_codevar;
	if( !app_code )
		app_code = 'eludia_app';
	app_title = app_titlevar;
	app_url = app_urlvar;
	if( !app_url )
		app_url = _guess_app_url();

	if( !confirm('�� ������� ���������� ���������� "'+app_title+'" �� ��� ���������?') )
		return false;

	try {
		var FSO = new ActiveXObject('Scripting.FileSystemObject');
		if( !FSO.FileExists(_get_HTA_fname()) || confirm('���������� "'+app_title+'" ��� �����������. ������������?') ) {
			_install_HTA( FSO, HTA_content );
		}
	}
	catch (err) {
		if( confirm('��������� ������ ��������� ����������: '+err.message+"!\n��������� ������������ ����?") ) {
			self.location.href = self.location.href+'&action=download';
		}
	}
}
