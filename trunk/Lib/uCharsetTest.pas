//* File:     Lib\uCharsetTest.pas
//* Created:  2001-12-01
//* Modified: 2007-05-06
//* Version:  1.1.40.9
//* Author:   David Safranek (Safrad)
//* E-Mail:   safrad at email.cz
//* Web:      http://safrad.own.cz

unit uCharsetTest;

interface

implementation

procedure Test;
var
	s: string;
begin
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
	ConvertCharset(s, cp1250, cpAscii);
	Assert(s = 'ACDEEINORSTUUYZacdeeinorstuuyz');

	s := 'Fr�hauf David';
	ConvertCharset(s, cp1250, cpAscii);
	Assert(s = 'Fruhauf David');
end;

initialization
	Test;
end.
