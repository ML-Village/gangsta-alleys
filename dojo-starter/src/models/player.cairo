use starknet::ContractAddress;
use dojo_starter::models::{position::Position};

#[derive(Model, Drop, Serde)]
struct Player {
    #[key]
    player_id: ContractAddress,
    health: u8,
    position: Position
}

#[generate_trait]
impl PlayerImpl of PlayerTrait {
    fn get_health(self: Player) -> u8 {
        self.health
    }

    fn damage_health(damage: u8, mut self: Player) -> bool {
        if self.health - damage == 0 {
            return true;
        } else {
            self.health = self.health - damage;
            return false;
        }
    }
}
