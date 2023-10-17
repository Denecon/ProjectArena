using Godot;
using System;
using Vector2 = Godot.Vector2;

public partial class player : CharacterBody3D
{
    [Export]
    private int MAX_SPEED = 100;
    [Export]
    private int ACCELERATION_SMOOTING = 10;
    private Vector2 targetPosition;

    private Vector2 mousePosition;


    public override void _Input(InputEvent @event)
    {
        base._Input(@event);

        if (@event is InputEventMouseMotion eventMouseMotion)
        {
            mousePosition = eventMouseMotion.GlobalPosition;
        }

    }

    public override void _Process(double delta) 
    {

        if (Input.IsActionJustPressed("mouse_button_1"))
        {
            targetPosition = mousePosition - new Vector2(GetViewport().GetVisibleRect().Size.X/2, GetViewport().GetVisibleRect().Size.Y/2) - new Vector2(GlobalPosition.X, GlobalPosition.Z);
            targetPosition = targetPosition.Normalized();
            
            
            GD.Print("GlobalPosition"+GlobalPosition);
            GD.Print("targetPosition"+targetPosition);
        }

        if (Position.DistanceTo(new Vector3(targetPosition.X, 0, targetPosition.Y)) > 1)
        {
            Velocity = new Vector3(targetPosition.X, 0, targetPosition.Y) * MAX_SPEED;
        }
        else
            Velocity = new Vector3(0, 0, 0);

        MoveAndSlide();
    }
}
