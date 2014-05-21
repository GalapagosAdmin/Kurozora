unit makkuro;
// Makkuro (Pitch Black) Library
// Copyright 2010 by Noah SILVA (印場乃亜)
// ALL RIGHTS RESERVED
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


CONST
 MaxX=100;
 MaxY=100;
 MaxZ=100;

TYPE
  TSector=record
    Beacon:String;
    Star_count:Integer;
    Ship_count:Integer;
    Mine_count:Integer;
    Planet_count:Integer;
    Station_count:Integer;
    Object_List:Pointer;
  end;

  TShip=record
    SectorX:Integer;
    SectorY:Integer;
    SectorZ:Integer;
    Shields:Integer;
    Fuel:Integer;
    Crew:Integer;
    Name:String;
    Alignment:Integer;
  end;


TYPE
  TUniverse = array [1..MaxX, 1..MaxY, 1..MaxZ] of TSector;



Function Ship_Location_GetString:String;
Function Ship_GetX:Integer;
Function Ship_GetY:Integer;
Function Ship_GetZ:Integer;

Function Sector_GetPlanets(Const X:Integer; y:Integer; Z:Integer):Integer;
Function Sector_GetStars(Const X:Integer; y:Integer; Z:Integer):Integer;
Function Sector_GetShips(Const X:Integer; y:Integer; Z:Integer):Integer;
Function Sector_GetStations(Const X:Integer; y:Integer; Z:Integer):Integer;
Function Sector_GetBeacon(Const X:Integer; y:Integer; Z:Integer):String;
Procedure Sector_SetBeacon(Const X:Integer; y:Integer; Z:Integer; NewMsg:String);
Procedure Ship_FlyTo(const x, y, z:Integer);

implementation

VAR
 Universe:TUniverse;
 Ship:TShip;

Function Ship_GetX:Integer;
  Begin
    Result := Ship.SectorX;
  end;
Function Ship_GetY:Integer;
  Begin
    Result := Ship.SectorY;
  end;
Function Ship_GetZ:Integer;
  Begin
    Result := Ship.SectorZ;
  end;

Function Ship_Location_GetString:String;
  begin
    Result := '[' + IntToStr(Ship_GetX) + ', '
                  + IntToStr(Ship_GetY) + ', '
                  + IntToStr(Ship_GetZ) + ']';
  end;

Function Sector_GetPlanets(Const X:Integer; y:Integer; Z:Integer):Integer;
  Begin
   Result := Universe[x, y, z].Planet_Count;
  End;

Function Sector_GetShips(Const X:Integer; y:Integer; Z:Integer):Integer;
  Begin
   Result := Universe[x, y, z].Ship_Count;
  End;

Function Sector_GetStations(Const X:Integer; y:Integer; Z:Integer):Integer;
  Begin
   Result := Universe[x, y, z].Station_Count;
  End;


Function Sector_GetStars(Const X:Integer; y:Integer; Z:Integer):Integer;
  Begin
   Result := Universe[x, y, z].Star_Count;
  End;

Function Sector_GetBeacon(Const X:Integer; y:Integer; Z:Integer):String;
  Begin
   Result := Universe[x, y, z].Beacon;
   If Result = '' Then Result := '- None -';
  end;

Procedure Sector_SetBeacon(Const X:Integer; y:Integer; Z:Integer; NewMsg:String);
  Begin
    Universe[x, y, z].Beacon := NewMsg;
  end;

Procedure Sector_Enter(Const X:Integer; y:Integer; Z:Integer);
  Begin
    Universe[x, y, z].Ship_Count := Universe[x, y, z].Ship_Count + 1;
  end;

Procedure Sector_Exit(Const X:Integer; y:Integer; Z:Integer);
  Begin
    Universe[x, y, z].Ship_Count := Universe[x, y, z].Ship_Count - 1;
  end;


Procedure Ship_FlyTo(const x, y, z:Integer);
  Begin
    Sector_Exit(Ship_GetX, Ship_GetY, Ship_GetZ);
    Ship.SectorX := x;
    Ship.SectorY := y;
    Ship.SectorZ := z;
    Sector_Enter(Ship_GetX, Ship_GetY, Ship_GetZ);
    Ship.Fuel := Ship.Fuel - 5;
  end;

initialization
 With Ship do Begin
   Name := 'Enforcer';
   SectorX := 1;
   SectorY := 1;
   SectorZ := 1;
   Shields := 100;
   Fuel := 50;
   Crew := 10;
   Alignment := 1;
 end; // of WITH SHIP
 Sector_SetBeacon(1,1,1, 'Home Base');
 Sector_Enter(1,1,1);
end. // of UNIT

