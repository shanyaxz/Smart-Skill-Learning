// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SkillEnhancement {

    struct Skill {
        string name;
        uint256 level; // e.g., 1-10 scale
        bool verified;
        address owner;
    }

    // Mapping from skill ID to Skill
    mapping(uint256 => Skill) public skills;
    // Mapping from user address to skill IDs
    mapping(address => uint256[]) public userSkills;
    // Total number of skills
    uint256 public totalSkills;

    // Events
    event SkillAdded(uint256 skillId, address indexed owner, string name, uint256 level);
    event SkillUpdated(uint256 skillId, uint256 newLevel);
    event SkillVerified(uint256 skillId, address indexed verifier);

    // Add a new skill
    function addSkill(string memory _name, uint256 _level) public {
        require(_level > 0 && _level <= 10, "Invalid skill level");

        skills[totalSkills] = Skill({
            name: _name,
            level: _level,
            verified: false,
            owner: msg.sender
        });

        userSkills[msg.sender].push(totalSkills);
        emit SkillAdded(totalSkills, msg.sender, _name, _level);
        totalSkills++;
    }

    // Update skill level
    function updateSkill(uint256 _skillId, uint256 _newLevel) public {
        require(_skillId < totalSkills, "Skill does not exist");
        Skill storage skill = skills[_skillId];
        require(skill.owner == msg.sender, "Only the owner can update the skill");
        require(_newLevel > 0 && _newLevel <= 10, "Invalid skill level");

        skill.level = _newLevel;
        emit SkillUpdated(_skillId, _newLevel);
    }

    // Verify a skill
    function verifySkill(uint256 _skillId) public {
        require(_skillId < totalSkills, "Skill does not exist");
        Skill storage skill = skills[_skillId];
        require(!skill.verified, "Skill already verified");

        skill.verified = true;
        emit SkillVerified(_skillId, msg.sender);
    }

    // Get skill details
    function getSkill(uint256 _skillId) public view returns (string memory name, uint256 level, bool verified, address owner) {
        require(_skillId < totalSkills, "Skill does not exist");
        Skill memory skill = skills[_skillId];
        return (skill.name, skill.level, skill.verified, skill.owner);
    }

    // Get all skills of a user
    function getUserSkills(address _user) public view returns (Skill[] memory) {
        uint256[] memory skillIds = userSkills[_user];
        Skill[] memory userSkillsList = new Skill[](skillIds.length);
        for (uint256 i = 0; i < skillIds.length; i++) {
            userSkillsList[i] = skills[skillIds[i]];
        }
        return userSkillsList;
    }
}
