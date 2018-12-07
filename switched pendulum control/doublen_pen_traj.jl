using RigidBodyDynamics

# place "Acrobot_with_limits.urdf" in the folder
urdf = joinpath("Acrobot_with_limits.urdf")
mechanism = parse_urdf(urdf)

#Controller, swing left and right
shoulder, elbow = joints(mechanism)
function simple_control!(torques::AbstractVector, t, state::MechanismState)
    if configuration(state)[1]>pi*0.4
        torques[velocity_range(state, shoulder)] .=0
        torques[velocity_range(state, elbow)] .= 0
    elseif configuration(state)[1]<0
        torques[velocity_range(state, shoulder)] .=-10
        torques[velocity_range(state, elbow)] .= 0
    else
        torques[velocity_range(state, shoulder)] .=15
        torques[velocity_range(state, elbow)] .= 0
    end
    #println(configuration(state)[1])
end
# Simulation
state = MechanismState(mechanism)
zero_velocity!(state)
set_configuration!(state, shoulder, 0)
set_configuration!(state, elbow, 0);
#  initial joint angle of the shoulder
#  joint angle in radians
final_time = 20.
ts, qs, vs = simulate(state, final_time, simple_control!; Δt = 1e-3);
#println(qs[1000][1])
using Plots
xs=Float64[]
ys=Float64[]
zs=Float64[]
ds=Float64[]
for q in qs[1:1:end]
    push!(xs,q[1])
    push!(zs,q[2])
end
for v in vs[1:1:end]
    push!(ys,v[1])
    push!(ds,v[2])
end
plot(ts,zs/pi*180,xlabel="Time",ylabel="Link1 position",legend=false)
plot!(ts,xs/pi*180,xlabel="Time",ylabel="Link1 position",legend=false)
