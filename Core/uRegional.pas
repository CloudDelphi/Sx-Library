unit uRegional;

interface

uses uTypes, Controls;

function DateToCS(const D: TDateTime): string; // Birthday, Players desription
function DateToCSLong(const D: TDateTime): string; // Chart legend
function DateToCSShort(const D: TDateTime): string; // Events

function IsNewYear(const ADate: TDate): BG;
function IsChristmas(const ADate: TDate): BG;
function IsPublicHolidayDay(const Date: TDateTime): BG;

function IsNewYearOnStartup: BG;
function IsChristmasOnStartup: BG;

implementation

uses
  SysUtils, DateUtils;

function DateToCS(const D: TDateTime): string; // Birthday, Players desription
begin
	if D = 0 then
		Result := '-'
	else
		DateTimeToString(Result, 'd.m.yyyy', D);
end;

function DateToCSLong(const D: TDateTime): string; // Chart legend
begin
	if D = 0 then
		Result := '-'
	else
		DateTimeToString(Result, 'dd.mm.yyyy', D);
end;

function DateToCSShort(const D: TDateTime): string; // Events
begin
	if D = 0 then
		Result := '-'
	else
		DateTimeToString(Result, 'd.m.', D);
end;

function IsNewYear(const ADate: TDate): BG;
var Day, Month, Year: U2;
begin
  DecodeDate(ADate, Year, Month, Day);
  Result := (Day = 1) and (Month = 1);
end;

function IsChristmas(const ADate: TDate): BG;
var Day, Month, Year: U2;
begin
  DecodeDate(ADate, Year, Month, Day);
  Result := (Day = 24) and (Month = 12);
end;

var
  GIsChristmasOnStartup: BG;
  GIsNewYearOnStartup: BG;

function IsNewYearOnStartup: BG;
begin
  Result := GIsNewYearOnStartup;
end;

function IsChristmasOnStartup: BG;
begin
  Result := GIsChristmasOnStartup;
end;

function IsPublicHolidayDay(const Date: TDateTime): BG;
var
  Day, Month, Year: U2;
begin
  Result := False; // TODO
  DecodeDate(Date, Year, Month, Day);
  case Month of
  1:
  begin
    if Day in [1] then
      Result := True;
  end;
  4:
  begin
    // TODO : Easter
  end;
  5:
  begin
    if Day in [1, 8] then
      Result := True;
  end;
  7:
  begin
    if Day in [5, 6] then
      Result := True;
  end;
  9:
  begin
    if Day in [28] then
      Result := True;
  end;
  10:
  begin
    if Day in [28] then
      Result := True;
  end;
  11:
  begin
    if Day in [17] then
      Result := True;
  end;
  12:
  begin
    if Day in [24, 25, 26] then
      Result := True;
  end;
  end;

end;

initialization
  GIsNewYearOnStartup := IsNewYear(Date);
  GIsChristmasOnStartup := IsChristmas(Date);
end.
