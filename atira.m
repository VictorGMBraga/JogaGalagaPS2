function atira
    import java.awt.Robot;
    robo = Robot;
    robo.keyPress(90); %Z
    robo.delay(10);
    %pause(0.1);
    robo.keyRelease(90);
end