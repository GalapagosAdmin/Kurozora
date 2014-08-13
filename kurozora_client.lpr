program kurozora_client;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, makkuro
  { you can add units after this };

type

  { TKuroZora }

  TKuroZora = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TKuroZora }

Procedure DoLook;
 begin
   Writeln('You are in sector ' + ship_location_getstring + '.');
   Writeln('Beacon:  ' + Sector_GetBeacon(Ship_GetX, Ship_GetY, Ship_GetZ));
   Writeln('Planets: ' + IntToStr(Sector_GetPlanets(Ship_GetX, Ship_GetY, Ship_GetZ)));
   Writeln('Stars:   ' + IntToStr(Sector_GetStars(Ship_GetX, Ship_GetY, Ship_GetZ)));
   Writeln('Ships:   ' + IntToStr(Sector_GetShips(Ship_GetX, Ship_GetY, Ship_GetZ)));
   Writeln('Stations:' + IntToStr(Sector_GetStations(Ship_GetX, Ship_GetY, Ship_GetZ)));
 end;

Procedure DoSetBeacon;
 Var
  tmp:String;
 Begin
   Writeln('Set New Beacon');
   Write('New Beacon:');
   Readln(Tmp);
   if tmp = '' then
    writeln('Set Beacon Command Cancelled.')
   else
     begin
       Sector_SetBeacon(Ship_GetX, Ship_GetY, Ship_GetZ, Tmp);
       Writeln('Beacon modified.');
     end;
 end;

Procedure DoGoTo;
  Var
   x:Integer;
   y:Integer;
   Z:Integer;
  Begin
    Writeln('Go to new sector');
    Write('X:');
    readln(X);
    Write('Y:');
    readln(Y);
    Write('Z:');
    readln(Z);
    Writeln('Setting course for ['+ IntToStr(x) + ','
                                  + IntToStr(y) + ','
                                  + IntToStr(z) + ']');
    Ship_FlyTo(x, y, z);
    Writeln('Now Arriving.');
    DoLook; // Show a Short Range Scan
  end;

procedure TKuroZora.DoRun;
var
  ErrorMsg: String;
  done:Boolean=False;
  cmd:String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  // Welcome Message
  Writeln('Welcome to Black Sky.');
  repeat
    Write('Command >');
    Readln(cmd);
    If Length(CMD) > 0 then
    Case UpCase(cmd[1]) of
      'B' :DoSetBeacon;              // Set Beacon In This Sector
      'G' :DoGoTo;                   // Fly to sector
      'H' :WriteHelp;  // Display Help Screen
      'I' :Writeln('Ship Info...');  // Status of own ship
      'L' :Writeln('Long Range Scan');             // Long range scan
      'M' :Writeln('Deploy Mines...');             // Leave Space Mines
      'S' :DoLook;                   // Look Around (Detailed Short Range Scan)
      'T' :Writeln('Terraforming Activities.');    // Planet Creation
      'Q' :Done := True;
      else
       Writeln('Unknown Command.');
    end; // of CASE
  until done;
  Writeln('Exiting...');
  // stop program loop
  Terminate;
end;

constructor TKuroZora.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TKuroZora.Destroy;
begin
  inherited Destroy;
end;

procedure TKuroZora.WriteHelp;
begin
  { add your help code here }
 // writeln('Usage: ',ExeName,' -h');
  writeln('B : Set Beacon In This Sector');
  writeln('G : Fly to sector');
  writeln('H : View Help...');  
  writeln('I : Ship Info...');  
  writeln('L : Long Range Scan');      
  writeln('M : Deploy Mines...');           
  writeln('S : Look Around (Detailed Short Range Scan');
  writeln('T : Terraforming Activities.');  
  writeln('Q : Quit');

end;

var
  Application: TKuroZora;

{$IFDEF WINDOWS}{$R kurozora_client.rc}{$ENDIF}

begin
  Application:=TKuroZora.Create(nil);
  Application.Title:='黒空：貿易戦争';
  Application.Run;
  Application.Free;
end.

