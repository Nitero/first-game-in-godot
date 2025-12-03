using FirstGame.project.core;
using Godot;

namespace FirstGame.project.features.score;

public partial class ScoreTracker : Node//TODO: does this really need to be a node? more lightweight than gameobjects so fine?
{
	private int score;

	public override void _Ready()
	{
		EventBus.CoinCollectedEvent += AddScore;
	}

	public override void _ExitTree()
	{
		EventBus.CoinCollectedEvent -= AddScore;
	}

	private void AddScore()
	{
		score++;
		EventBus.ScoreChangedEvent?.Invoke(score);
	}
}