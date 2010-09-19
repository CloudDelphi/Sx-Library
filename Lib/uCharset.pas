unit uCharset;

interface

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

procedure ConvertCharset(var s: string; FromCharset, ToCharset: TCodePage); overload;
function ConvertCharsetF(const s: string; FromCharset: TCodePage; ToCharset: TCodePage): string; overload;

function UpCaseCz(const s: string): string;
function DelCz(const s: string): string;

implementation

uses uTypes;

type
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

procedure ConvertCharset(var s: string; FromCharset: TCodePage; ToCharset: TCodePage); overload;
var
	i: SG;
{	c, d: Char;
	CP: array[Char] of Char;}
begin
	Assert(FromCharset <> cpAscii);
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
			s[i] := CP[s[i]];
		end;
	end;}
end;

function ConvertCharsetF(const s: string; FromCharset: TCodePage; ToCharset: TCodePage): string; overload;
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
	end;
	{$ifopt d+}
	// Tests
	s := '������������������';
	ConvertCharset(s, cp1250, cp852);
	Assert(s = '���Ԃء�墓��眣��');

	s := '�';
	ConvertCharset(s, cp1250, cp852);
	Assert(s = '�');

	s := '��������؊���ݎ���������������';
	ConvertCharset(s, cp1250, cp852);
	Assert(s = '��Ґ����������Ԃء��眣��');

	s := '��Ґ����������Ԃء��眣��';
	ConvertCharset(s, cp852, cp1250);
	Assert(s = '��������؊���ݎ���������������');

	s := '��������ة���ݮ���������������';
	ConvertCharset(s, cpISO88592, cp1250);
	Assert(s = '��������؊���ݎ���������������');

	s := '��������؊���ݎ���������������';
	ConvertCharset(s, cp1250, cpISO88592);
	Assert(s = '��������ة���ݮ���������������');

	s := '��Ґ����������Ԃء��眣��';
	ConvertCharset(s, cp852, cpISO88592);
	Assert(s = '��������ة���ݮ���������������');

	s := '��������ة���ݮ���������������';
	ConvertCharset(s, cpISO88592, cp852);
	Assert(s = '��Ґ����������Ԃء��眣��');

	s := '��������؊���ݎ���������������';
	s := DelCz(s);
	Assert(s = 'ACDEEINORSTUUYZacdeeinorstuuyz');

	s := 'Fr�hauf David';
	s := DelCz(s);
	Assert(s = 'Fruhauf David');
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

initialization
	FillCharsTable;
end.

