using Godot;
using System;
using FirstGame.project.features.score;

public partial class Bootstrap : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		AddChild(new ScoreTracker());
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}