#include "snakegame.h"

#include <SDL.h>

SnakeGame::SnakeGame()
    : m_canRun(true)
{
}

SnakeGame::~SnakeGame()
{
}

int SnakeGame::run()
{
    SDL_Event event;
    while (m_canRun)
    {
        if (SDL_PollEvent(&event) != 0)
        {
            if (event.type == SDL_QUIT)
            {
                m_canRun = false;
            }
        }
    }
    return 0;
}
