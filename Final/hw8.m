function swinging_spring()
    % Parameters
    g = 9.8;
    m = 1;
    k = 100;
    Ln = 0.5;

    % Initial conditions:
    % y, dy/dt, theta, dtheta/dt 
    y0 = 0.2;
    dy0 = 0;
    theta0 = deg2rad(1);  % convert to radians
    dtheta0 = 0;

    % Initial state vector
    init = [y0; dy0; theta0; dtheta0];

    % Time span
    tspan = [0 16];

    % Solve ODEs
    [t, Y] = ode45(@(t, Y) odefun(t, Y, g, m, k, Ln), tspan, init);

    % Extract solutions
    y = Y(:,1);
    theta = rad2deg(Y(:,3)); % convert back to degrees for interpretability

    % Plot
    figure;
    subplot(2,1,1)
    plot(t, y)
    xlabel('Time (s)')
    ylabel('y(t) [m]')
    title('Spring Extension y(t)')

    subplot(2,1,2)
    plot(t, theta)
    xlabel('Time (s)')
    ylabel('\theta(t) [deg]')
    title('Angle \theta(t)')
end

function dY = odefun(~, Y, g, m, k, Ln)
    y = Y(1); dy = Y(2); theta = Y(3); dtheta = Y(4);

    ddy = g * cos(theta) + (Ln + y) * dtheta^2 - k * y / m;
    ddtheta = (-g * sin(theta) - 2 * dy * dtheta) / (Ln + y);

    dY = [dy; ddy; dtheta; ddtheta];
end
