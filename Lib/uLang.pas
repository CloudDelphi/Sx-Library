//* File:     Lib\uLang.pas
//* Created:  1999-11-01
//* Modified: 2004-11-08
//* Version:  X.X.33.X
//* Author:   Safranek David (Safrad)
//* E-Mail:   safrad@email.cz
//* Web:      http://safrad.webzdarma.cz

unit uLang;

interface

type
	TCodePage = (cpAscii, cp1250, cp852, cpISO88592, cpKeybCS2, cpMacCE,
		cpKOI8CS, cpkodxx, cpWFW_311, cpISO88591, cpT1, cpMEXSK, cpw311_cw,
		cpVavrusa, cpNavi);

procedure ConvertCharset(var s: string; FromCharset, ToCharset: TCodePage);

function UpCaseCz(const s: string): string;
function DelCz(const s: string): string;

function DosCzSkToWin(const s: string): string;

function WinCzSkToDos(const s: string): string;
function WinPlToDos(const s: string): string;
function WinHuToDos(const s: string): string;

var
	TableUpCaseCz,
	TableDelCz,
	TableDosCzToWin,
	TableWinCzSkToDos,
	TableWinPlToDos,
	TableWinHuToDos: array[Char] of Char;

implementation

uses
	Dialogs, SysUtils,
	uAdd, uError, uStrings;

type
	TCzLetters = array[0..29] of Char;
const
	CZX: array [TCodePage] of TCzLetters =
	 ('ACDEEINORSTUUYZacdeeinorstuuyz', // ASCII
		'��������؊���ݎ���������������', // CP1250
		'��Ґ����������Ԃء��眣��', // CP852 (LATIN 2)
		'��������ة���ݮ���������������', // ISO-8859-2
		'������������������������������', // KEYBCS2 (Kamenicky)
		'牑�����������뇋����˗������', // MAC CE
		'������������������������������', // KOI8-CS
		'������ҡ؊���ݎ���������������', // kodxx
		'��������؊�ڡݡ���������������', // WFW_3-11
		'0CD�E�+�RST�U�Z�cd�e�n�rst�u�z', // ISO-8859-1
		'�����͉Ӥ���ү���������ޔ��ۘ�', // T1
		'��������؊�ڡݎ���������������', // MEXSK
		'�%������؊���ݎ���������������', // w311_ce
		'��������؊�ڡݎ���������������', // vavrusa
		'��������+��ڡݡ���������������'); // navi


procedure ConvertCharset(var s: string; FromCharset, ToCharset: TCodePage);
var
	i: SG;
	c, d: Char;
	CP: array[Char] of Char;
begin
	// Fill
	for c := Low(c) to High(c) do
	begin
		d := c;
		for i := Low(TCzLetters) to High(TCzLetters) do
		begin
			if CZX[FromCharset][i] = c then
			begin
				d := CZX[ToCharset][i];
			end;
		end;
		CP[c] := d;
	end;

	// Convert
	for i := 1 to Length(s) do
	begin
		s[i] := CP[s[i]];
	end;
end;

procedure FillCharsTable;
var c, Result: Char;
begin
	for c := Low(c) to High(c) do
	begin
		// UpCaseCz
		case c of
		'a'..'z': Result := Chr(Ord(c) - Ord('a') + Ord('A'));
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		else Result := c;
		end;
		TableUpCaseCz[c] := Result;

		// DelCz
		case c of
		'�': Result := 'a';
		'�': Result := 'c';
		'�': Result := 'd';
		'�': Result := 'e';
		'�': Result := 'e';
		'�': Result := 'i';
		'�': Result := 'n';
		'�': Result := 'o';
		'�': Result := 'r';
		'�': Result := 's';
		'�': Result := 't';
		'�': Result := 'u';
		'�': Result := 'u';
		'�': Result := 'y';
		'�': Result := 'z';

		'�': Result := 'A';
		'�': Result := 'C';
		'�': Result := 'D';
		'�': Result := 'E';
		'�': Result := 'E';
		'�': Result := 'I';
		'�': Result := 'N';
		'�': Result := 'O';
		'�': Result := 'R';
		'�': Result := 'S';
		'�': Result := 'T';
		'�': Result := 'U';
		'�': Result := 'U';
		'�': Result := 'Y';
		'�': Result := 'Z';
		else Result := c;
		end;
		TableDelCz[c] := Result;

		// DosCzToWin (852 to 1250)
		case c of
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';

		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		else Result := c;
		end;
		TableDosCzToWin[c] := Result;

		// WinCzSkToDos
		case c of
		#32..#127: Result := c;
		'�': Result := '�'; // 132 ???SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // SK
		'�': Result := '�'; // 234 ???SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';

		'�': Result := '�'; // 142 ???SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 214
		'�': Result := '�'; //     SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 226 SK
		'�': Result := '�'; // 232 ???SK
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		else Result := CharNul;
		end;
		TableWinCzSkToDos[c] := Result;

		// WinPlToDos
		case c of
		#32..#127: Result := c;
		'�': Result := '�';
		'�': Result := '�'; // 165
		'�': Result := '�'; // 134
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 136
		'�': Result := '�';
		'�': Result := '�'; // 162
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';

		'�': Result := '�';
		'�': Result := '�'; // 164
		'�': Result := '�'; // 143
		'�': Result := '�'; // 168
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 157
		'�': Result := '�'; // 227
		'�': Result := '�'; // 224
		'�': Result := '�';
		'�': Result := 'y'; // 151
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 141
		'�': Result := '�'; // 189
		'�': Result := '�';
		else Result := CharNul;
		end;
		TableWinPlToDos[c] := Result;

		// WinHuToDos
		case c of
		#32..#127: Result := c;
		'�': Result := '�'; // 132
		'�': Result := '�'; // 160
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 139
		'�': Result := '�'; // 148
		'�': Result := '�'; // 147
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 129
		'�': Result := '�'; // 251
		'�': Result := '�';

		'�': Result := '�'; // 142
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 138
		'�': Result := '�'; // 153
		'�': Result := '�'; // 226
		'�': Result := '�';
		'�': Result := '�';
		'�': Result := '�'; // 154
		'�': Result := '�'; // 235
		'�': Result := '�';
		else Result := CharNul;
		end;
		TableWinHuToDos[c] := Result;
	end;
end;

function UpCaseCz(const s: string): string;
var i: Integer;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		Result[i] := TableUpCaseCz[s[i]];
	end;
end;

function DelCz(const s: string): string;
var i: Integer;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(Result) do
	begin
		Result[i] := TableDelCz[s[i]];
	end;
end;

function DosCzSkToWin(const s: string): string;
var i: Integer;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		Result[i] := TableDosCzToWin[s[i]];
	end;
end;

function WinCzSkToDos(const s: string): string;
var
	i: Integer;
	c: Char;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		c := TableWinCzSkToDos[s[i]];
		if c = CharNul then
		begin
			Result[i] := s[i];
			MessageD('Unknown char ' + s[i] + ' (' + IntToStr(Ord(s[i])) + ')', mtError, [mbOk]);
		end
		else
			Result[i] := c;
	end;
end;

function WinPlToDos(const s: string): string;
var
	i: Integer;
	c: Char;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		c := TableWinPlToDos[s[i]];
		if c = CharNul then
		begin
			Result[i] := s[i];
			MessageD('Unknown char ' + s[i] + ' (' + IntToStr(Ord(s[i])) + ')', mtError, [mbOk]);
		end
		else
			Result[i] := c;
	end;
end;

function WinHuToDos(const s: string): string;
var
	i: Integer;
	c: Char;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		c := TableWinHuToDos[s[i]];
		Result[i] := c;
		if c = CharNul then
		begin
			Result[i] := s[i];
			MessageD('Unknown char ' + s[i], mtError, [mbOk]);
		end
		else
			Result[i] := c;
	end;
end;

initialization
	FillCharsTable;
end.
