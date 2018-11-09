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
	a := '��������؊���ݎ���������������';
	a := ConvertToAscii(a);
	Check(a = 'ACDEEINORSTUUYZacdeeinorstuuyz', 'cpLocal -> cpAscii');

	w := '��������؊���ݎ���������������';
	a := ConvertToAscii(w);
	Check(a = 'ACDEEINORSTUUYZacdeeinorstuuyz', 'cpLocal -> cpAscii');
end;

initialization
	RegisterTest('Charset Test', TCharsetTest.Suite);
end.
