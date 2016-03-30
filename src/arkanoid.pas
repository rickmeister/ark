program arkanoid;

uses
  SDL2,
  SDL2_image,
  arktypes,
  arkman;

var
  tm: TTextureManager;
  ark: TArkanoid;
  ptx: PSDL_Texture;
  id: Integer;
begin
  SDL_Init(SDL_INIT_EVERYTHING);
  IMG_Init(IMG_INIT_PNG);
  ark := TArkanoid.Create;
  ark.PWindow := SDL_CreateWindow('Arkanoid', 0, 0, 640, 360, SDL_WINDOW_SHOWN);
  ark.PRenderer := SDL_CreateRenderer(ark.PWindow, -1, SDL_RENDERER_ACCELERATED);
  tm := TTextureManager.Create(@ark);
  tm.LoadTexture('assets/menu/exit_n.png');
  tm.LoadTexture('assets/menu/exit_h.png');
  tm.LoadTexture('assets/menu/exit_c.png');
  id:=tm.LoadTexture('assets/menu/exit_l.png');
  tm.LoadTexture('assets/menu/exit_n.png');
  writeln('id: ', id);
  ptx:=tm.GetTexture(id);
  SDL_RenderCopy(ark.PRenderer, ptx, nil, nil);
  SDL_RenderPresent(ark.PRenderer);
  tm.ReleaseTexture(id);
  SDL_Delay(1000);
  tm.Destroy;
  SDL_DestroyRenderer(ark.PRenderer);
  SDL_DestroyWindow(ark.PWindow);
  IMG_Quit;
  SDL_Quit;
end.
