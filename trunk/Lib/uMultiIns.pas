//* File:     Lib\uMultiIns.pas
//* Created:  2000-05-01
//* Modified: 2007-11-27
//* Version:  1.1.39.8
//* Author:   David Safranek (Safrad)
//* E-Mail:   safrad at email.cz
//* Web:      http://safrad.own.cz

unit uMultiIns;

interface

uses
	uTypes,
	Windows, SysUtils, Messages;

var
	MessageId: UINT;

procedure InitInstance;

implementation

uses uMsg, uStrings, uFiles, uParams, Forms;

const
	wmMainInstanceOpenFile = WM_USER + 3;

var
	WProc: TFNWndProc;
	MutHandle: THandle;

function NewWndProc(Handle: HWND; Msg: UINT; wParam, lParam: LongInt): LRESULT; stdcall;
var
	CmdLine: string;
begin
	if (Msg = MessageID) then
	begin
		Result := 0;
		if IsIconic(Handle) = False then
		begin
			ShowWindow(Handle, SW_SHOW); // SW_NORMAL, SW_RESTORE break windows stay on top!
			SetForegroundWindow(Handle);
		end;

		SetLength(CmdLine, MAX_PATH);
		SetLength(CmdLine, GlobalGetAtomName(wParam, PChar(CmdLine), MAX_PATH));
		if Length(CmdLine) = 0 then
			ErrorMsg(GetLastError)
		else
		begin
			ReadCommandLine(CmdLine);
			GlobalDeleteAtom(wParam);
		end;
	end
	else
		Result := CallWindowProc(WProc, Handle, Msg, wParam, lParam); // pass message on to old window proc
end;

procedure BroadcastFocusMessage(wParam, lParam: LongInt);
var
	BSMRecipients: DWORD;
begin
	// Post message and inform other instance to focus itself
	BSMRecipients := BSM_APPLICATIONS;
	BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
		@BSMRecipients, MessageID, wParam, lParam);
end;

procedure InitInstance;
var
	Atom: TAtom;
	UniqueAppStr: string;
begin
	UniqueAppStr := DelCharsF(ShortToLongPath(ParamStr(0)), PathDelim);
	MessageID := RegisterWindowMessage(PChar(UniqueAppStr));
	MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, PChar(UniqueAppStr));
	if MutHandle = 0 then
	begin
		{
			Mutex object has not yet been created, meaning that no previous instance has been created.
			We subclass Application window procedure so that Application.OnMessage remains available for user.
		}
		WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(@NewWndProc)));
		{ Set appropriate error flag if error condition occurred }
		if WProc = nil then
			ErrorMsg(GetLastError);

		MutHandle := CreateMutex(nil, False, PChar(UniqueAppStr));
		if MutHandle = 0 then
			ErrorMsg(GetLastError);
	end
	else
	begin
// TODO if not RegisterParam(-NewInstance) then
		begin
			Atom := GlobalAddAtom(PChar(GetCommandLine));
			BroadcastFocusMessage(Atom, 0);
			Halt(1);
		end;
	end;
end;

initialization

finalization
	if WProc <> nil then
	begin
		SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(WProc));
		WProc := nil;
	end;
	if MutHandle <> 0 then
	begin
		CloseHandle(MutHandle);
		MutHandle := 0;
	end;
end.
