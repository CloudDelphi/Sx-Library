// * File:     Lib\uCSVFile.pas
// * Created:  2007-03-10
// * Modified: 2009-09-21
// * Version:  1.1.45.113
// * Author:   David Safranek (Safrad)
// * E-Mail:   safrad at email.cz
// * Web:      http://safrad.own.cz

unit uCSVFile;

interface

uses
	SysUtils,
	uTypes, uFile;

const
	CSVSep = ','; // ;
	CSVRemark = '#';

type
	TCSVFile = class
	private
		{ Private declarations }
		FFile: TFile;
		FColumnCount: SG;
		FLineIndex: SG;
	public
		{ Public declarations }
		AcceptRemark: BG;
		constructor Create(const ColumnCount: SG);
		destructor Destroy; override;

		function ReadLine: TArrayOfString;
		function Open(const FileName: TFileName): BG;
		function Close: BG;
		function EOF: BG;
	property
		LineIndex: SG read FLineIndex;
	end;

procedure CreateCSVHead(const FileName: TFileName; const Head: array of string);

implementation

uses
	Windows,
	uStrings,
	uFiles;

procedure CreateCSVHead(const FileName: TFileName; const Head: array of string);
var
	i: SG;
	f, s: string;
	LineIndex: SG;
	l: string;
begin
	s := CSVRemark;
	for i := 0 to Length(Head) - 1 do
	begin
		if i <> 0 then
			s := s + CSVSep;
		s := s + '"' + Head[i] + '"';
	end;
	s := s + FileSep;
	if FileExists(FileName) = False then
	begin
		WriteStringToFile(FileName, s, False);
	end
	else
	begin
		f := ReadStringFromFile(FileName);
		LineIndex := 1;
		l := ReadToNewLine(f, LineIndex) + FileSep;
		if l <> s then
		begin
			Delete(f, 1, LineIndex - 1);
			Insert(s, f, 1);
			WriteStringToFile(FileName, f, False);
		end;
	end;
end;

{ TCSVFile }

constructor TCSVFile.Create(const ColumnCount: SG);
begin
	Assert(ColumnCount >= 0);
	FColumnCount := ColumnCount;
	AcceptRemark := False;
	FFile := TFile.Create;

	inherited Create;
end;

destructor TCSVFile.Destroy;
begin
	Close;
	FreeAndNil(FFile);
	inherited;
end;

function TCSVFile.ReadLine: TArrayOfString;
var
	Line: string;
	InLineIndex: SG;
	ColumnIndex: SG;
	LastIndex: SG;
	Quoted: BG;
begin
	Result := nil;
	if Assigned(FFile) and (FFile.Opened) then
	begin
		SetLength(Result, FColumnCount);
		while FFile.Readln(Line) do
		begin
			if Line = '' then Continue; // Empty line
			if (Line[1] = CSVRemark) and (AcceptRemark = False) then Continue; // Remark line
			LastIndex := 1;
			InLineIndex := 1;
			ColumnIndex := 0;
			Quoted := False;
			while InLineIndex <= Length(Line) do
			begin
				case Line[InLineIndex] of
				'"':
				begin
					if (Quoted = False) {and (LastIndex = InLineIndex)} {FirstColumnChar} then
					begin
						Quoted := True;
						if LastIndex = InLineIndex then
							Inc(LastIndex) // Skip First Quote
						else
						begin
							Delete(Line, InLineIndex, 1); // Delete quote
							Dec(InLineIndex);
						end;
					end
					else
					begin
						if Quoted then
						begin
							if CharAt(Line, InLineIndex + 1) = '"' then
							begin // Convert two quotes to one.
								Delete(Line, InLineIndex, 1);
							end
							else
							begin
//								Assert(CharAt(Line, InLineIndex + 1) in [',', ';', CharTab];
								Quoted := False;
								Delete(Line, InLineIndex, 1); // Delete last quote
								Dec(InLineIndex);
							end;
						end;


{						if CharAt(Line, InLineIndex - 1) in ['"', '\'] then
						begin
							// Normal Char
							Delete(Line, InLineIndex - 1, 1);
							Dec(InLineIndex);
						end
						else
						begin
							if LastIndex = InLineIndex then
								Inc(LastIndex) // Skip First Quote
							else
							begin
								Delete(Line, InLineIndex, 1);
								Dec(InLineIndex);
							end;
							Quoted := not Quoted;
						end;}
					end;
				end;
				',', ';', CharTab: // Column separators
				begin
					if Quoted = False then
					begin
						if FColumnCount = 0 then
						begin
							SetLength(Result, ColumnIndex + 1);
							Result[ColumnIndex] := Copy(Line, LastIndex, InLineIndex - LastIndex);
						end
						else if ColumnIndex < FColumnCount then
						begin
							Result[ColumnIndex] := Copy(Line, LastIndex, InLineIndex - LastIndex);
						end;
						Inc(ColumnIndex);
						LastIndex := InLineIndex + 1;
					end;
					// else char is part of value
				end;
				end;

				Inc(InLineIndex);
			end;
			if FColumnCount = 0 then
			begin
				SetLength(Result, ColumnIndex + 1);
				Result[ColumnIndex] := Copy(Line, LastIndex, InLineIndex - LastIndex);
			end
			else if ColumnIndex < FColumnCount then
			begin
				Result[ColumnIndex] := Copy(Line, LastIndex, InLineIndex - LastIndex);
			end;

			Inc(FLineIndex);
			Break;
		end;
	end;
end;

function TCSVFile.Open(const FileName: TFileName): BG;
begin
	Result := FFile.Open(FileName, fmReadOnly);
end;

function TCSVFile.Close: BG;
begin
	Result := True;
	if Assigned(FFile) then
	begin
		if FFile.Opened then
			Result := FFile.Close;
	end;
end;

function TCSVFile.EOF: BG;
begin
	Result := True;
	if Assigned(FFile) and (FFile.Opened) then
		Result := FFile.Eof;
end;

end.
