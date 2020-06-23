from genray.wrapper import genray_actor 
import imas

if __name__ == "__main__":
    # import os
    # os.environ['USER'] = 'fydev'
    imas_obj = imas.ids(63982, 48)
    # Create a new instance of database
    imas_obj.open_env("fydev", "test", "3")

    imas_obj.equilibrium.get()
    imas_obj.core_profiles.get()
    imas_obj.ec_launchers.get()
    genray_actor(imas_obj.equilibrium,imas_obj.core_profiles,imas_obj.ec_launchers)