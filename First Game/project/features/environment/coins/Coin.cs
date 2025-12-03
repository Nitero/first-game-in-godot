using System;
using System.Threading.Tasks;
using FirstGame.project.core;
using Godot;

namespace FirstGame.project.features.environment.coins;

public partial class Coin : Area2D
{
	private AnimationPlayer _animationPlayer;

	public override void _Ready()
	{
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		BodyEntered += OnBodyEntered;
	}

	public override void _ExitTree()
	{
		BodyEntered -= OnBodyEntered;
	}

	private void OnBodyEntered(Node2D body)
	{
		EventBus.CoinCollectedEvent?.Invoke();
		_animationPlayer.Play("pickup");//TODO: why need animation at all? hide + play sound from code? oh because sound stops when we delete it too soon
		Task.Delay(TimeSpan.FromSeconds(1f)).ContinueWith(_ =>//TODO: take delay from the length of the animation
		{
			QueueFree();
		});
	}
}