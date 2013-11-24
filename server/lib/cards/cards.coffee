exports.OneOne =
  name: "OneOne"
  cost: 1
  abilities: {}
  attack: 1
  health: 1
  imgSrc: '/images/peasant.jpg'

exports.TwoTwo =
  name: "TwoTwo"
  cost: 2
  abilities: {}
  attack: 2
  health: 2
  imgSrc: '/images/knight.jpg'

exports.DrawOne =
  name: "Draw"
  cost: 1
  positive: true
  abilities: [
    name: "draw"
    value: 1
    cost: 0
    validTargets:
      self: true
      opponent: true
  ]
  imgSrc: '/images/draw.jpg'

exports.DrawThree =
  name: "Draw"
  cost: 2
  positive: true
  abilities: [
    name: "draw"
    value: 3
    cost: 0
    validTargets:
      self: true
      opponent: true
  ]
  imgSrc: '/images/draw.jpg'

exports.DamageTwo =
  name: "Damage"
  cost: 1
  positive: true
  abilities: [
    name: "damage"
    value: 2
    cost: 0
    validTargets:
      self: true
      opponent: true
      monsters: true
  ]
  imgSrc: '/images/wizard.jpg'

exports.DamageFive =
  name: "Damage"
  cost: 3
  positive: true
  abilities: [
    name: "damage"
    value: 5
    cost: 0
    validTargets:
      self: true
      opponent: true
      monsters: true
  ]
  imgSrc: '/images/wizard.jpg'

exports.HealThree =
  name: "Heal"
  cost: 1
  positive: true
  abilities: [
    name: "heal"
    value: 3
    cost: 0
    validTargets:
      self: true
      opponent: true
      monsters: true
  ]
  imgSrc: '/images/heal.jpg'

exports.HealTen =
  name: "Heal"
  cost: 5
  positive: true
  abilities: [
    name: "heal"
    value: 10
    cost: 0
    validTargets:
      self: true
      opponent: true
      monsters: true
  ]
  imgSrc: '/images/heal.jpg'

exports.DamageAllTwo =
  name: "DamageAll"
  cost: 2
  positive: true
  abilities: [
    name: "damageAll"
    value: 2
    cost: 0
    validTargets:
      all: true
      players: true
      monsters: true
  ]
  imgSrc: '/images/damage-all.jpg'

exports.DamageAllFour =
  name: "DamageAll"
  cost: 5
  positive: true
  abilities: [
    name: "damageAll"
    value: 4
    cost: 0
    validTargets:
      all: true
      players: true
      monsters: true
  ]
  imgSrc: '/images/damage-all.jpg'



