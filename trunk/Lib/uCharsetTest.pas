unit uCharsetTest;

interface

uses TestFrameWork;

type
  TCharsetTest = class(TTestCase)
  published
    procedure Test;
  end;

implementation

uses uTypes, uCharset;

{ TCharsetTest }

procedure TCharsetTest.Test;
var
	a: AnsiString;
	w: UnicodeString;
begin
	// Tests
	a := '������������������';
	ConvertCharset(a, cp1250, cp852);
	Assert(a = '���Ԃء�墓��眣��');

	a := '�';
	ConvertCharset(a, cp1250, cp852);
	Assert(a = '�');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cp852);
	Assert(a = '��Ґ����������Ԃء��眣��');

	a := '��Ґ����������Ԃء��眣��';
	ConvertCharset(a, cp852, cp1250);
	Assert(a = '��������؊���ݎ���������������');

	a := '��������ة���ݮ���������������';
	ConvertCharset(a, cpISO88592, cp1250);
	Assert(a = '��������؊���ݎ���������������');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cpISO88592);
	Assert(a = '��������ة���ݮ���������������');

	a := '��Ґ����������Ԃء��眣��';
	ConvertCharset(a, cp852, cpISO88592);
	Assert(a = '��������ة���ݮ���������������');

	a := '��������ة���ݮ���������������';
	ConvertCharset(a, cpISO88592, cp852);
	Assert(a = '��Ґ����������Ԃء��眣��');

	a := 'Fr�hauf David';
	ConvertCharset(a, cp1250, cpAscii);
	Assert(a = 'Fruhauf David');

	a := '��������؊���ݎ���������������';
	ConvertCharset(a, cp1250, cpAscii);
	Assert(a = 'ACDEEINORSTUUYZacdeeinorstuuyz');

	a := '��������؊���ݎ���������������';
	a := ConvertToAscii(a);
	Assert(a = 'ACDEEINORSTUUYZacdeeinorstuuyz');

	w := '��������؊���ݎ���������������';
	a := ConvertToAscii(w);
	Assert(a = 'ACDEEINORSTUUYZacdeeinorstuuyz');

end;

initialization
	RegisterTest('Charset Test', TCharsetTest.Suite);
end.
