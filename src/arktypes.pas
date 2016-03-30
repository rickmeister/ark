unit arktypes;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, SDL2, SDL2_image;

type

  TGameState = (GameInit, GameRun, GamePause, GameLvlup, GameQuit);

  TArkanoid = class(TObject)
  public
	PWindow: PSDL_Window;
	PRenderer: PSDL_Renderer;
  end;

implementation

end.
