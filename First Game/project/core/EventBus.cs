using System;

namespace FirstGame.project.core;

internal static class EventBus
{
    public static Action CoinCollectedEvent;
    public static Action<int> ScoreChangedEvent;
}