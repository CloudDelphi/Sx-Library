unit uObjectFactoryTest;

interface

uses TestFrameWork;

type
  TObjectFactoryTest = class(TTestCase)
  published
    procedure Test;
  end;

implementation

uses
  uObjectFactory;

{ TObjectFactoryTest }

procedure TObjectFactoryTest.Test;
var
  ObjectFactory: TObjectFactory;
begin
  ObjectFactory := TObjectFactory.Create;
  try

  finally
    ObjectFactory.Free;
  end;

  CheckTrue(True, '');
end;

initialization
	RegisterTest('Object Factory Test', TObjectFactoryTest.Suite);
end.
