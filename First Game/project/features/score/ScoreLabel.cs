using FirstGame.project.core;
using Godot;

namespace FirstGame.project.features.score;

[Tool]
public partial class ScoreLabel : Label
{
	[Export]
	public string Format { get; set; } = "You collected %s coins";

	public override void _Ready()
	{
		if (!Engine.IsEditorHint())
			OnScoreChanged(0);
		EventBus.ScoreChangedEvent += OnScoreChanged;
	}

	public override void _ExitTree()
	{
		EventBus.ScoreChangedEvent -= OnScoreChanged;
	}

	public override void _Process(double delta)
	{
		if (Engine.IsEditorHint())
			OnScoreChanged(9999);
	}

	private void OnScoreChanged(int score)
	{
		Text = Format.Replace("%s", score.ToString());
	}
}