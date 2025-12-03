using Godot;

namespace FirstGame.project.features.player;

public sealed partial class Player : CharacterBody2D
{
    private const float Speed = 130;
    private const float JumpVelocity = -300;

    private AnimatedSprite2D _animatedSprite;
    private float _gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

    public override void _Ready()
    {
        _animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
    }

    public override void _Process(double delta)
    {
        PlayAnimation();
    }

    public override void _PhysicsProcess(double delta)
    {
        Vector2 velocity = Velocity;
        if (!IsOnFloor())
            velocity.Y += _gravity * (float) delta;
        else if (Input.IsActionJustPressed("jump"))
            velocity.Y = JumpVelocity;

        float direction = Input.GetAxis("move_left", "move_right");//-1 | 0 | 1
        if (direction > 0)
            _animatedSprite.FlipH = false;
        else if(direction < 0)
            _animatedSprite.FlipH = true;

        if (Mathf.Abs(direction) > Mathf.Epsilon)
            velocity.X = direction * Speed;
        else
            velocity.X = Mathf.MoveToward(velocity.X, 0, Speed);

        Velocity = velocity;
        MoveAndSlide();
    }

    private void PlayAnimation()
    {
        if (IsOnFloor())
            _animatedSprite.Play(Mathf.IsEqualApprox(Velocity.X, 0f) ? "idle" : "run");
        else
            _animatedSprite.Play("jump");
    }
}