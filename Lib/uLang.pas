//* File:     Lib\uLang.pas
//* Created:  1999-11-01
//* Modified: 2005-06-21
//* Version:  X.X.34.X
//* Author:   Safranek David (Safrad)
//* E-Mail:   safrad@centrum.cz
//* Web:      http://safrad.webzdarma.cz

unit uLang;

interface

uses SysUtils;

type
	TCodePage = (cpAscii, cp1250, cp852, cpISO88592{, cpKeybCS2, cpMacCE,
		cpKOI8CS, cpkodxx, cpWFW_311, cpISO88591, cpT1, cpMEXSK, cpw311_cw,
		cpVavrusa, cpNavi});
var
	TableUpCaseCz{,
	TableDelCz,
	TableDosCzToWin,
	TableWinCzSkToDos,
	TableWinPlToDos,
	TableWinHuToDos}: array[Char] of Char;

procedure ConvertCharset(var s: ShortString; FromCharset: TCodePage; ToCharset: TCodePage); overload;
procedure ConvertCharset(var s: string; FromCharset, ToCharset: TCodePage); overload;
function ConvertCharsetF(s: string; FromCharset: TCodePage; ToCharset: TCodePage): string; overload;

function UpCaseCz(const s: string): string;
function DelCz(const s: string): string;

{function DosCzSkToWin(const s: string): string;

function WinCzSkToDos(const s: string): string;
function WinPlToDos(const s: string): string;
function WinHuToDos(const s: string): string;}

//Alphabet
procedure ReadAlphabet(FileName: TFileName);
function AlphaStrToWideStr(Line: string): WideString;

// Dictionary
procedure ReadDictionary(FileName: TFileName);
function Translate(Line: string): string; overload;
procedure TranslateFile(FileName: TFileName); overload;

implementation

uses
	Dialogs, Windows,
	uTypes, uError, uStrings, uFiles, uSorts, uFind, uParser;

type
//	TCzLetters = array[0..29] of Char;
{const
	CZX: array[TCodePage] of TCzLetters =
	 ('ACDEEINORSTUUYZacdeeinorstuuyz', // ASCII
		'��������؊���ݎ���������������', // ANSI-CP1250
		'��Ґ����������Ԃء��眣��', // OEM-CP852 (LATIN 2)
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
	 }

	TUpAscii = array[#128..#255] of Char;

var
	// [to, from]
	CodePage: array[TCodePage, cp1250..High(TCodePage)] of TUpAscii = (
		(
		// to ASCII
		'E�'+#$27+'�".++�%S<STZZ�'+#$27+#$27+'"".--�ts>stzz   LoA| cS<--RZ~+ l'+#$27+'u. as>L lzRAAAALCCCEEEEIIDDNNOOOOxRUUUUYTbraaaalccceeeeiiddnnoooo/ruuuuyt ', // from CP1250
		'CueaauccleOoiZACELlooLlSsOUTtLxcaiouAaZzEe-zCs<>   ||AAES||++Zz++++|-|Aa++==|=|odDDEdNIIe++  TU ObONnnSsRUrUyYt'+#$27+'-    / ~  uRr  ', // from OEM-CP852 (LATIN 2)
		'�������������������������������� A LoLS SSTZ-ZZ~a l'+#$27+'ls  sstz zzRAAAALCCCEEEEIIDDNNOOOOxRUUUUYTbraaaalccceeeeiiddnnoooo/ruuuuyt '  // from ISO-8859-2
		)
		,
		(
		// to CP1250
		'��������������������������������������������������������������������������������������������������������������������������������', // from CP1250
		'������������������������܍�������������꬟Ⱥ��   ||��̪||++��++++|-|��++==|=|����������++  �� ���������������������������� �', // from OEM-CP852 (LATIN 2)
		'��������������������������������������������������������������������������������������������������������������������������������' // from ISO-8859-2
		)
		,
		(
		// to OEM-CP852 (LATIN 2)
		'E�'+#$27+'�".�ň%�<�����'+#$27+#$27+'"".--�t�>��������Ϥ|��c����R��+��u.������赶Ǝ������ӷ�������⊙��������ꠃǄ�������ء����墓�����������', // from CP1250
		'��������������������������������������������������������������������������������������������������������������������������������', // from OEM-CP852 (LATIN 2)
		'������������������������������������ϕ���減�������筜��赶Ǝ������ӷ�������⊙��������ꠃǄ�������ء����墓�����������' // from ISO-8859-2
		)
		,
		(
		// to ISO-8859-2
		'E�'+#$27+'�".++�%�<�����'+#$27+#$27+'"".--�t�>����������|��c�<-�R��+���u.���>��������������������������������������������������������������������', // from CP1250
		'������������������������ܫ��������������-�Ⱥ<>   ||��̪||++��++++|-|��++==|=|����������++  �� ���������������������������� �', // from OEM-CP852 (LATIN 2)
		'��������������������������������������������������������������������������������������������������������������������������������' // from ISO-8859-2
		)
	);
{
Unicode
�	00C1	�	00CD	�	0164
�	00E1	�	00ED	�	0165
�	010C	�	0147	�	00DA
�	010D	�	0148	�	00FA
�	010E	�	00D3	�	016E
�	010F	�	00F3	�	016F
�	00C9	�	0158	�	00DD
�	00E9	�	0159	�	00FD
�	011A	�	0160	�	017D
�	011B	�	0161	�	017E
}

procedure ConvertCharset(var s: ShortString; FromCharset: TCodePage; ToCharset: TCodePage); overload;
var
	i: SG;
begin
	if FromCharset = cpAscii then
	begin
		{$ifopt d+}IE(434);{$endif}
		Exit;
	end;
	for i := 1 to Length(s) do
	begin
		if Ord(s[i]) >= $80 then
			s[i] := CodePage[ToCharset, FromCharset][s[i]];
	end;
end;

procedure ConvertCharset(var s: string; FromCharset: TCodePage; ToCharset: TCodePage); overload;
var
	i: SG;
{	c, d: Char;
	CP: array[Char] of Char;}
begin
	if FromCharset = cpAscii then
	begin
		{$ifopt d+}IE(434);{$endif}
		Exit;
	end;
{	if ToCharset = cp1250 then
	begin}
		for i := 1 to Length(s) do
		begin
			if Ord(s[i]) >= $80 then
				s[i] := CodePage[ToCharset, FromCharset][s[i]];
		end;
{	end
	else
	begin
		// Fill
		for c := Low(c) to High(c) do
		begin
			d := #0;
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
			if CP[s[i]] = '#0' then
				IE(34);
			s[i] := CP[s[i]];
		end;
	end;}
end;

function ConvertCharsetF(s: string; FromCharset: TCodePage; ToCharset: TCodePage): string; overload;
var
	i: SG;
begin
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		if Ord(s[i]) >= $80 then
			Result[i] := CodePage[ToCharset, FromCharset][s[i]]
		else
			Result[i] := s[i];
	end;
end;

procedure FillCharsTable;
var c, Result: Char;
{$ifopt d+}s: string;{$endif}
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

{		// DelCz
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
		TableWinHuToDos[c] := Result;}
	end;
	{$ifopt d+}
	// Test if works

{		#32..#127: Result := c;
		'': Result := ''; // 132
		'': Result := ''; // 160
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := ''; // 139
		'': Result := ''; // 148
		'': Result := ''; // 147
		'': Result := '';
		'': Result := '';
		'': Result := ''; // 129
		'': Result := ''; // 251
		'': Result := '';

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
		'�': Result := '�';}


{	s := '�������������';
	ConvertCharset(s, cp1250, cp852);
	if s <> '�������������' then IE(434);}

{		#32..#127: Result := c;
		'': Result := '';
		'': Result := ''; // 165
		'': Result := ''; // 134
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := ''; // 136
		'': Result := '';
		'': Result := ''; // 162
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';

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
		'�': Result := '�';}

{	s := '��������������';
	ConvertCharset(s, cp1250, cp852);
	if s <> '����ء�����쫾�' then IE(434);}

		// WinCzSkToDos
{		case c of
		#32..#127: Result := c;
		'': Result := ''; // 132 ???SK
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := ''; // SK
		'': Result := '';
		'': Result := '';
		'': Result := ''; // SK
		'': Result := ''; // 234 ???SK
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';
		'': Result := '';

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
		end;}

	s := '������������������';
	ConvertCharset(s, cp1250, cp852);
	if s <> '���Ԃء�墓��眣��' then IE(434);

	s := '�';
	ConvertCharset(s, cp1250, cp852);
	if s <> '�' then IE(434);

	s := '��������؊���ݎ���������������';
	ConvertCharset(s, cp1250, cp852);
	if s <> '��Ґ����������Ԃء��眣��' then IE(434);

	s := '��Ґ����������Ԃء��眣��';
	ConvertCharset(s, cp852, cp1250);
	if s <> '��������؊���ݎ���������������' then IE(434);

	s := '��������ة���ݮ���������������';
	ConvertCharset(s, cpISO88592, cp1250);
	if s <> '��������؊���ݎ���������������' then IE(434);

	s := '��������؊���ݎ���������������';
	ConvertCharset(s, cp1250, cpISO88592);
	if s <> '��������ة���ݮ���������������' then IE(434);

	s := '��Ґ����������Ԃء��眣��';
	ConvertCharset(s, cp852, cpISO88592);
	if s <> '��������ة���ݮ���������������' then IE(434);

	s := '��������ة���ݮ���������������';
	ConvertCharset(s, cpISO88592, cp852);
	if s <> '��Ґ����������Ԃء��眣��' then IE(434);



	s := '��������؊���ݎ���������������';
	s := DelCz(s);
	if s <> 'ACDEEINORSTUUYZacdeeinorstuuyz' then
		IE(544);
	s := 'Fr�hauf David';
	s := DelCz(s);
	if s <> 'Fruhauf David' then
		IE(544);
	{$endif}
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
begin
	Result := s;
	ConvertCharset(Result, cp1250, cpAscii);
end;

{
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
end;}

// Alphabet
var
	Alpha: array of string;
	AlphaCount: Integer;

procedure ReadAlphabet(FileName: TFileName);
label LRetry;
var
	F: TFile;
	s: string;
begin
	F := TFile.Create;
	LRetry:
	AlphaCount := 0; SetLength(Alpha, 0);
	if F.Open(FileName, fmReadOnly, FILE_FLAG_SEQUENTIAL_SCAN, False) then
	begin
		while not F.Eof do
		begin
			F.Readln(s);
			if Length(s) > 0 then
			begin
				SetLength(Alpha, AlphaCount + 1);
				Alpha[AlphaCount] := s;
				Inc(AlphaCount);
			end;
		end;
		if not F.Close then goto LRetry;
	end;
	F.Free;
end;

function AlphaCharToWord(Line: string; var InLineIndex: Integer): Word;
var
	i: Integer;
	Found: Integer;
begin
	Result := Ord(Line[InLineIndex]);
	Found := 0;
	for i := 0 to AlphaCount - 1 do
	begin
		if Copy(Line, InLineIndex, Length(Alpha[i])) = Alpha[i] then
		begin
			if Length(Alpha[i]) > Found then
			begin
				Result := 65 + i;
				Found := Length(Alpha[i]);
			end;
		end;
	end;
	if Found > 0 then
	begin
		Inc(InLineIndex, Found);
	end
	else
	begin
		if Ord(Line[InLineIndex]) >= 123 then
			Result := Ord(Line[InLineIndex]) + 256
		else
			Result := Ord(Line[InLineIndex]);
		Inc(InLineIndex);
	end;
end;

function AlphaStrToWideStr(Line: string): WideString;
var i, j: Integer;
begin
	SetLength(Result, Length(Line));
	i := 1;
	while i <= Length(Line) do
	begin
		j := i;
		Result[j] := WideChar(AlphaCharToWord(Line, i));
	end;
end;

// Dictionary
type
	TDict = packed record
		Cz, En: string;
	end;
var
	Dict: array of TDict;
	DictCount: SG;
	AIndex: array of SG;
	AValue: array of U4;

procedure ReadDictionary(FileName: TFileName);
var
	Line: string;
	InLineIndex: SG;
	i: SG;
begin
	Line := ReadStringFromFile(FileName);
	InLineIndex := 1;
	DictCount := 0;
	while InLineIndex < Length(Line) do
	begin
		Inc(DictCount);
		SetLength(Dict, DictCount);

		Dict[DictCount - 1].Cz := ReadToChar(Line, InLineIndex, CharTab);
		Dict[DictCount - 1].En := ReadToChar(Line, InLineIndex, CharCR);
		ReadToChar(Line, InLineIndex, CharLF);
	end;
	// Read dictionary
	SetLength(AIndex, DictCount);
	SetLength(AValue, DictCount);
	for i := 0 to DictCount - 1 do
	begin
		AIndex[i] := i;
		AValue[i] := Length(Dict[i].Cz);
	end;

	SortU4(False, True, PArraySG(@AIndex[0]), PArrayU4(@AValue[0]), DictCount);
end;

function Translate(Line: string): string; overload;
var
	i, j, Index, Po: SG;
	WhatS, WhatS2, ToS: string;
begin
	for j := 0 to DictCount - 1 do
	begin
		i := AIndex[j];
		Index := 1;
		WhatS := UpCaseCz(Dict[i].Cz);
		while Index < Length(Line) do
		begin
			Po := Find(WhatS, UpCaseCz(Line), Index);

			if (Po <> 0) then
			begin
				if (CharsTable[Line[Po - 1]] <> ctLetter)
				and (CharsTable[Line[Po + Length(WhatS)]] <> ctLetter)
				and (Line[Po - 1] <> '<')
				and (Line[Po - 1] <> '/')
				and (Ord(Line[Po - 1]) < 128)
				and (Ord(Line[Po + Length(WhatS)]) < 128) then
				begin
					if Line[Po] = Dict[i].Cz[1] then
						ToS := Dict[i].En
					else
					begin
						ToS := Dict[i].En;
						ToS[1] := UpCase(ToS[1]);
					end;

					WhatS2 := Dict[i].Cz;
					Delete(Line, Po, Length(WhatS2));
					Insert(ToS, Line, Po);
					Index := Po + Length(ToS);
				end
				else
					Index := Po + Length(WhatS);
			end
			else
				Break;
		end;

//		Replace(Line, Dict[i].Cz, Dict[i].En);
	end;
//	ConvertCharset(Line, cp1250, cpISO88592);
	Result := Line;
end;

procedure TranslateFile(FileName: TFileName); overload;
var
	FileNameEn: TFileName;
	Line: string;
begin
	Line := Translate(ReadStringFromFile(FileName));
	FileNameEn := Translate(ExtractFileName(FileName));
	if FileNameEn <> FileName then
		FileName := AddAfterName(FileName, 'En')
	else
		FileName := AddAfterName(FileName, 'En');
	WriteStringToFile(FileName, Line, False);

end;

procedure _finalization;
begin
	SetLength(Alpha, 0);
	SetLength(AIndex, 0);
	SetLength(AValue, 0);
	SetLength(Dict, 0);
end;

initialization
	FillCharsTable;
finalization
	_finalization;
end.
