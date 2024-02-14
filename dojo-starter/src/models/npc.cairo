use starknet::ContractAddress;
use dojo_starter::models::{position::Position};

#[derive(Model, Drop, Serde)]
struct Npc {
    #[key]
    npc_id: u8,
    health: u8,
    position: Position
}

#[generate_trait]
impl NpcImpl of NpcTrait {
    fn get_health(self: Npc) -> u8 {
        self.health
    }

    fn damage_health(damage: u8, mut self: Npc) -> bool {
        if self.health - damage == 0 {
            return true;
        } else {
            self.health = self.health - damage;
            return false;
        }
    }
}
