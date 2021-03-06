unit uEloFunctions;

interface

uses
  Velthuis.BigDecimals,
  uTypes, uVector, uOutputFormat;

type
	TElo = SG;
const
	ScoreOne = 100;

function GetElo(const Fruitfulness: BigDecimal): TElo;
function GetEloI(const Fruitfulness: SG): TElo;
function GetArcElo(const EloDifference: BigDecimal): BigDecimal;
function ExpectedRes(Elo, OpElo: TElo; Bonus: SG; Rounded: BG): SG;
function DeltaElo(const Elo, AvgElo: TElo; Age: TDateTime; Score, GameCount: SG): BigDecimal;
function DeltaEloI(const Elo, AvgElo: TElo; const Age: TDateTime; const Score, GameCount: SG): SG;

function ScoreToS(const Score: SG; const HTML: BG = True): string;
function EloToStr(const Elo: TElo; const OutputFormat: TOutputFormat): string;
function HaveElo(const AElo: TElo): BG;

implementation

uses
	SysUtils,
  uStrings,
	uNamespace, uMath;

const
	EloTableCount = 100;
var
	EloTable: array[0..EloTableCount div 2] of SG = (
		765{6}, 677, 589, 538, 501, 470, 444, 422, 401, 383, 368,
		351, 336, 322, 309, 296, 284, 273, 262, 251, 240,
		230, 220, 211, 202, 193, 184, 175, 166, 158, 149,
		141, 133, 125, 117, 110, 102, 95, 87, 80,
		72, 65, 57, 50, 43, 36, 29, 21, 14, 7, 0);
// 0,5 + 1,4217 * 10^(-3) * x - 2,4336 * 10^(-7) * x * Abs(x) - 2,5140 * 10^(-9) * x * Abs(x)^2 + 1,9910 * 10^(-12) * x * Abs(x)^3

function GetElo(const Fruitfulness: BigDecimal): TElo;
begin
	if Fruitfulness <= 0 then
		Result := -EloTable[0]
	else if Fruitfulness >= 1 then
		Result := EloTable[0]
	else if Fruitfulness < 0.5 then
		Result := -EloTable[BigDecimal.Round(EloTableCount * Fruitfulness)]
	else
		Result := EloTable[EloTableCount - BigDecimal.Round(EloTableCount * Fruitfulness)];
end;

function GetEloI(const Fruitfulness: SG): TElo;
begin
	if Fruitfulness <= 0 then
		Result := -EloTable[0]
	else if Fruitfulness >= EloTableCount then
		Result := EloTable[0]
	else if Fruitfulness < EloTableCount div 2 then
		Result := -EloTable[Fruitfulness]
	else
		Result := EloTable[EloTableCount - Fruitfulness];
end;

function GetArcElo(const EloDifference: BigDecimal): BigDecimal;
var
	i: SG;
	e0, e1: BigDecimal;
begin
	e0 := MaxInt;
	Result := 0;
	for i := 0 to 100 do
	begin
		e1 := BigDecimal.Abs(GetElo(BigDecimal(i) / 100) - EloDifference);
		if e1 < e0 then
		begin
			e0 := e1;
			Result := BigDecimal(i) / 100;
		end;
	end;
end;

function GetArcEloI(const EloDifference: SG): SG;
var
	i: SG;
	e0, e1: SG;
begin
	e0 := MaxInt;
	Result := 0;
	for i := 0 to 100 do
	begin
		e1 := Abs(GetEloI(i) - EloDifference);
		if e1 < e0 then
		begin
			e0 := e1;
			Result := i;
		end;
	end;
end;

function ExpectedRes(Elo, OpElo: TElo; Bonus: SG; Rounded: BG): SG;
const // Calibrate
	WhitePlus = 193;
	StartElo = 1350;
	WhiteBonus = 59;
begin
	if Elo = 0 then Elo := StartElo;
	if OpElo = 0 then OpElo := StartElo;
	if Bonus < 0 then
		Inc(OpElo, WhiteBonus)
	else if Bonus > 0 then
		Inc(Elo, WhiteBonus);

	if Rounded then
	begin
		if Elo >= OpElo + WhitePlus then
		begin
			Result := ScoreOne
		end
		else if Elo + WhitePlus <= OpElo then
		begin
			Result := 0
		end
		else
			Result := ScoreOne div 2;
	end
	else
	begin
		Result := BigDecimal.Round(ScoreOne * GetArcElo(Elo - OpElo));
	end;
end;

function Elo(const Args: array of TVector): TVector;
var
	i: SG;
	ArgCount: SG;
	e: BigDecimal;
begin
	ArgCount := Length(Args);
	if ArgCount = 0 then
//		Result := 0
	else if ArgCount = 1 then
		Result := NumToVector(GetELO(Args[0][0]))
	else if ArgCount >= 2 then
	begin
		e := 0;
		for i := 0 to ArgCount - 2 do
		begin
			e := e + VectorToNum(Args[i]);
		end;
		Result := NumToVector(e / (ArgCount - 1) +
			GetELO(VectorToNum(Args[ArgCount - 1])) / (ArgCount - 1));
	end;
end;

function ArcElo(const Args: array of TVector): TVector;
var
	i: SG;
	ArgCount: SG;
	e: BigDecimal;
begin
	ArgCount := Length(Args);
	if ArgCount = 0 then
		e := 0
	else if ArgCount = 1 then
		e := VectorToNum(Args[0])
	else
	begin
		e := 0;
		for i := 0 to ArgCount - 1 do
		begin
			e := e + VectorToNum(Args[i]);
		end;
	end;
	Result := NumToVector(GetArcElo(e));
end;

function DeltaElo(const Elo, AvgElo: TElo; Age: TDateTime; Score, GameCount: SG): BigDecimal;
var
	Coef: SG;
begin
	if Elo >= 2400 then
		Coef := 10
	else if (Age < 20 * 365) and (Elo < 2200) then
		Coef := 25
	else
		Coef := 15;
	Result := Coef * (BigDecimal(Score) / ScoreOne - BigDecimal(BigDecimal.Round(100 * GameCount * GetArcElo(Elo - AvgElo))) / 100);
end;

function DeltaEloI(const Elo, AvgElo: TElo; const Age: TDateTime; const Score, GameCount: SG): SG;
var
	Coef: SG;
begin
	if Elo >= 2400 then
		Coef := 10
	else if (Age < 20 * 365) and (Elo < 2200) then
		Coef := 25
	else
		Coef := 15;
	Result := Coef * (Score - GameCount * GetArcEloI(Elo - AvgElo));
end;

function EloC(const Args: array of TVector): TVector;
var
	i, j: SG;
	ArgCount: SG;
	e, e0, e1, MyElo: BigDecimal;
begin
	ArgCount := Length(Args);
	if ArgCount < 3 then
//		Result := 0
	else
	begin // Delta / Performance
(*
		e0 := Calc(Node.Args[1]
		e := Calc(Node.Args[0]);
		Result := 0;
		for i := 1 to Node.ArgCount div 2 - 1 do
		begin
			e1 := ArcElo(e0) - Calc(Node.Args[2 * i]));
			Result := Result + (1 * e * (Calc(Node.Args[2 * i + 1]) - e1)) / 1;
		end;*)

		if ArgCount and 1 = 0 then
			MyElo := VectorToNum(Args[1])
		else
			MyElo := 300;
//			Calc(Node.Args[0]); // Skip your elo

		e := 0; // Suma Elo
		e1 := 0; // Suma Score
		j := 0;
		for i := 1 to (ArgCount + 1) div 2 - 1 do
		begin
			e0 := VectorToNum(Args[2 * i - (ArgCount and 1)]);
			if e0 > 0 then
			begin
				if ArgCount and 1 = 0 then
					if e0 < MyElo - 300 then
            e0 := MyElo - 300; // New for year 2005
				e := e + e0;
				e1 := e1 + VectorToNum(Args[2 * i + 1 - (ArgCount and 1)]); // Score
				Inc(j);
			end;
		end;
		if j > 0 then
		begin
			e0 := BigDecimal.Round(e / j); // Avg opponets elo
			if ArgCount and 1 = 0 then
				Result := NumToVector(BigDecimal.Round(VectorToNum(Args[0])){Delta} * (e1 - BigDecimal(BigDecimal.Round(GetArcElo(MyElo - e0) * 100 * j)) / 100))
			else
				Result := NumToVector(e0{Avg opponets elo} + GetELO(e1 / j));
		end;
	end;
end;

function ScoreToS(const Score: SG; const HTML: BG = True): string;
var
	Res, Rem: U2;
begin
	if Score = -1 then
	begin
		Result := '?';
		Exit;
	end;

	DivModU4(Score, ScoreOne, Res, Rem);
	if (Res > 0) or (Rem = 0) then
		Result := NToS(Res)
	else
		Result := '';
	if (Rem <> 0) or (HTML = False) then
	begin
		if HTML then
		begin
			if Rem = ScoreOne div 2 then
				Result := Result + '&frac12;'
			else if Rem = ScoreOne div 4 then
				Result := Result + '&frac14;'
			else if Rem = 3 * ScoreOne div 4 then
				Result := Result + '&frac34;'
			else
				Result := Result + ',' + NToS(Rem, '00');
		end
		else
			Result := Result + ',' + NToS(Rem, '00');
	end;
end;

function EloToStr(const Elo: TElo; const OutputFormat: TOutputFormat): string;
begin
	if Elo = 0 then
	begin
		case OutputFormat of
		ofHTML: Result := nbsp;
		ofIO: Result := '0';
		else Result := '';
		end;
	end
	else
	begin
		Result := IntToStr(Elo);
	end;
end;

function HaveElo(const AElo: TElo): BG;
begin
	Result := (AElo > 1250{MinimalELO}); //and (AElo <> 1000) and (AElo <> 1100) and (AElo <> 1250);
end;

initialization
{$IFNDEF NoInitialization}
	AddFunction('Chess', 'Elo', Elo, 'Probably Elo difference for result <0..1>. ' + WikipediaURLPrefix + 'Elo_rating_system#Performance_rating');
	AddFunction('Chess', 'ArcElo', ArcElo, 'Probably result <0..1> for Elo difference. ' + WikipediaURLPrefix + 'Elo_rating_system#Performance_rating');
	AddFunction('Chess', 'EloC', EloC, '([Coef.]; Your elo; 1st opponent elo; 1st opponent result; 2nd opponent elo; 2nd opponent result...)');
	AddFunction('Chess', 'EloDif', EloC, 'Return elo difference (Coef.; Your elo; 1st opponent elo; 1st opponent result; 2nd opponent elo; 2nd opponent result...) ' + WikipediaURLPrefix + 'Elo_rating_system#Performance_rating');
	AddFunction('Chess', 'EloPerfo', EloC, 'Return Elo performance (Your elo; 1st opponent elo; 1st opponent result; 2nd opponent elo; 2nd opponent result...) ' + WikipediaURLPrefix + 'Elo_rating_system#Performance_rating');
{$ENDIF NoInitialization}
end.
