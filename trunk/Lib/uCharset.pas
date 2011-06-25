//* File:     Lib\uCharset.pas
//* Created:  2001-12-01
//* Modified: 2008-02-23
//* Version:  1.1.41.12
//* Author:   David Safranek (Safrad)
//* E-Mail:   safrad at email.cz
//* Web:      http://safrad.own.cz

unit uCharset;

interface

type
	TCodePage =
		(cpAscii, cp1250, cp852, cpISO88592{, cpKeybCS2, cpMacCE,
		cpKOI8CS, cpkodxx, cpWFW_311, cpISO88591, cpT1, cpMEXSK, cpw311_cw,
		cpVavrusa, cpNavi}, cpUTF8, cpUnicode);
{
TODO: Unicode
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

const
	CodePageNames: array[TCodePage] of string =
		('ASCII', 'windows-1250'{Central European, Windows Latin 2}, 'IBM852'{DOS code page for Central European}, 'ISO-8859-2'{Central European, ISO Latin 2}, 'utf-8', 'utf-16');

procedure ConvertCharset(var s: string; const FromCharset, ToCharset: TCodePage);
function ConvertCharsetF(const s: string; const FromCharset, ToCharset: TCodePage): string;

var
	TableUpCaseCz: array[Char] of Char;

function UpCaseCz(const s: string): string;

implementation

uses uTypes;

type
{const
	CZX: array[TCodePage] of TCzLetters = (
		'ACDEEINORSTUUYZacdeeinorstuuyz', // ASCII
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
	CodePage: array[cpAscii..cpISO88592, cp1250..cpISO88592] of TUpAscii = (
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

procedure ConvertCharset(var s: string; const FromCharset, ToCharset: TCodePage);
var
	i: SG;
{	c, d: Char;
	CP: array[Char] of Char;}
begin
	Assert(FromCharset <> cpAscii);
	if FromCharset = ToCharset then Exit;

	if (FromCharset = cpUTF8) then
	begin
		s := Utf8ToAnsi(s);
		if (ToCharset <> cp1250) then
			ConvertCharset(s, cp1250, ToCharset);
		Exit;
	end;

	if (ToCharset = cpUTF8) then
	begin
		if (FromCharset <> cp1250) then
			ConvertCharset(s, FromCharset, cp1250);
		s := AnsiToUtf8(s);
		Exit;
	end;

	if (FromCharset = cpUnicode) then
	begin
		UnicodeToUtf8(PAnsiChar(s), PWideChar(PChar(s)), 2 * Length(s)); // TODO Need test
		if (ToCharset <> cpUTF8) then
			ConvertCharset(s, cpUTF8, ToCharset);
		Exit;
	end;

	if (ToCharset = cpUnicode) then
	begin
		if (FromCharset <> cpUTF8) then
			ConvertCharset(s, FromCharset, cpUTF8);
		Utf8ToUnicode(PWideChar(PChar(s)), PAnsiChar(s), 2 * Length(s)); // TODO, Buffer required?, Need test
		Exit;
	end;

	for i := 1 to Length(s) do
	begin
		if Ord(s[i]) >= $80 then
			s[i] := CodePage[ToCharset, FromCharset][s[i]];
	end;
end;

function ConvertCharsetF(const s: string; const  FromCharset, ToCharset: TCodePage): string;
{var
	i: SG;}
begin
	Result := s;
	ConvertCharset(Result, FromCharset, ToCharset);
{	Assert(FromCharset <> cpAscii);
	SetLength(Result, Length(s));
	for i := 1 to Length(s) do
	begin
		if Ord(s[i]) >= $80 then
			Result[i] := CodePage[ToCharset, FromCharset][s[i]]
		else
			Result[i] := s[i];
	end;}
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

initialization
	FillCharsTable;
end.                                                                          
