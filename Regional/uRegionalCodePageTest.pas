unit uRegionalCodePageTest;

interface

uses TestFrameWork;

type
  TRegionalCodePageTest = class(TTestCase)
  published
    procedure Test;
  end;

implementation

uses uTypes, uRegionalCodePage;

{ RegionalCodePageTest }

procedure TRegionalCodePageTest.Test;
var
	a: AnsiString;
	w: UnicodeString;
begin
	// Tests
	a := '������������������';
	ConvertCharset(a, cp1250, cp852);
	Check(a = '���Ԃء�墓��眣��', 'cp1250 -> cp852');

	a := '�';
	ConvertCharset(a, cp1250, cp852);
	Check(a = '�', 'cp1250 -> cp852');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cp852);
	Check(a = '��Ґ����������Ԃء��眣��', 'cp1250 -> cp852');

	a := '��Ґ����������Ԃء��眣��';
	ConvertCharset(a, cp852, cp1250);
	Check(a = '��������؊���ݎ���������������', 'cp852 -> cp1250');

	a := '��������ة���ݮ���������������';
	ConvertCharset(a, cpISO88592, cp1250);
	Check(a = '��������؊���ݎ���������������', 'cpISO8859-2 -> cp1250');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cpISO88592);
	Check(a = '��������ة���ݮ���������������', 'cp1250 -> cpISO8859-2');

	a := '��Ґ����������Ԃء��眣��';
	ConvertCharset(a, cp852, cpISO88592);
	Check(a = '��������ة���ݮ���������������', 'cp852 -> cpISO8859-2');

	a := '��������ة���ݮ���������������';
	ConvertCharset(a, cpISO88592, cp852);
	Check(a = '��Ґ����������Ԃء��眣��', 'cpISO8859-2 -> cp852');

	a := 'Fr�hauf David';
	ConvertCharset(a, cp1250, cpAscii);
	Check(a = 'Fruhauf David', 'cp1250 -> cpAscii');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cpAscii);
	Check(a = 'ACDEEINORSTUUYZacdeeinorstuuyz', 'cp1250 -> cpAscii');
end;

initialization
	RegisterTest('Regional Code Page Test', TRegionalCodePageTest.Suite);
end.
