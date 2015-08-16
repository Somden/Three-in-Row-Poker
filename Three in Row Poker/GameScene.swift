//
//  GameScene.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    var CardHeight: CGFloat = 70.0
    var CardWidth: CGFloat = 45.0
    
    private struct Margin {
        static let left: CGFloat = 10
        static let right: CGFloat = 10
        static let top: CGFloat = 90
        static let bottom: CGFloat = 90
    }
    
    let gameBoardLayer = SKNode()
    let layerPosition = CGPoint(x: 10.0, y: Margin.bottom)
    
    var textureCache = [String: SKTexture]()
    
    
    struct Durations {
        static let showCardDuration: NSTimeInterval = 0.5
        static let changeCardAnimation = (
            hidePreviousCardAnimationDuration: 0.5,
            showNewCardAnimationDuration: 0.5
        )
        static let moveCardDuration: NSTimeInterval = 0.7
        static let removeCardDuration: NSTimeInterval = 1.0
        static let fallCardDuration: NSTimeInterval = 0.7
        static let comboAnimation = (
            showComboAnimationDuration: 0.2,
            waitComboAnimationDuration: 1.0,
            hideComboAnimationDuration: 0.2
        )
    }
    
    
    struct Colors {
        static let backgroundColor: UIColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1.0)
        static let comboBackgroundColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        static let comboTextColor: UIColor = UIColor.redColor()
        static let transparent: UIColor = UIColor(white: 1, alpha: 0)
    }
    
    
    override init(size: CGSize) {
        CardHeight = (size.height - Margin.top - Margin.bottom) / CGFloat(Game.NumOfRows)
        CardWidth = (size.width - Margin.left - Margin.right) / CGFloat(Game.NumOfColumns)
        
        super.init(size: size)
        
        
        // let backgroundTextutre = SKTexture(imageNamed: "background")
        // let background = SKSpriteNode(texture: backgroundTextutre, size: size)
        let background = SKSpriteNode(color: Colors.backgroundColor, size: size)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(background)
        
        addChild(gameBoardLayer)
        
        let gameBoardSize = CGSizeMake(CardWidth * CGFloat(Game.NumOfColumns), CardHeight * CGFloat(Game.NumOfRows))
        let gameBoard = SKSpriteNode(color: Colors.backgroundColor.colorWithAlphaComponent(0), size: gameBoardSize)
        gameBoard.anchorPoint = CGPoint(x: 0, y: 0)
        gameBoard.position = layerPosition
        
        gameBoardLayer.addChild(gameBoard)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func pointForPosition(#column: Int, row: Int) -> CGPoint {
        let x: CGFloat = layerPosition.x + CardWidth * CGFloat(column) + CardWidth/2
        let y: CGFloat = layerPosition.y + CardHeight * CGFloat(row) + CardHeight/2
        
        return CGPoint(x: x, y: y)
    }
    
    func positionForPoint(point: CGPoint) -> (row: Int, column: Int) {
        var row: Int = Int(floor((point.y - layerPosition.y) / CardHeight))
        var column: Int = Int(floor((point.x - layerPosition.x) / CardWidth))
        
        return (row, column)
    }
    
    
    
    // Cards positioning functions
    
    func showCard(card: Card, completion: () -> ()) {

        
        
        let sprite = createSpriteForCard(card)
        
        gameBoardLayer.addChild(sprite)
        card.sprite = sprite
        
        sprite.alpha = 0
        let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: Durations.showCardDuration)
        fadeInAction.timingMode = .EaseOut
        
        sprite.runAction(fadeInAction, completion: completion)
    }
    
    func showCards(cards: [Card?], completion: () -> ()) {
        for card in cards {
            if card != nil {
                self.showCard(card!) {}
            }
        }
        
        runAction(SKAction.waitForDuration(Durations.showCardDuration), completion: completion)
    }
    
    func showCards(cards: [Card], completion: () -> ()) {
        for card in cards {
            self.showCard(card) {}
        }
        
        runAction(SKAction.waitForDuration(Durations.showCardDuration), completion: completion)
    }
    
    
    func changeCard(#oldCard: Card, newCard: Card, completion: () -> ()) {
        var removeAnimation = SKAction.fadeAlphaTo(0, duration: Durations.changeCardAnimation.hidePreviousCardAnimationDuration)
        removeAnimation.timingMode = .EaseOut
        
        newCard.sprite?.alpha = 0
        var showAnimation = SKAction.fadeAlphaTo(1, duration: Durations.changeCardAnimation.showNewCardAnimationDuration)
        showAnimation.timingMode = .EaseOut
        
        oldCard.sprite?.runAction(removeAnimation) {
            oldCard.sprite?.removeFromParent()
            
            let sprite = self.createSpriteForCard(newCard)
            self.gameBoardLayer.addChild(sprite)
            newCard.sprite = sprite
            
            newCard.sprite?.runAction(showAnimation) {}
        }
        
        let totalDuration = Durations.changeCardAnimation.hidePreviousCardAnimationDuration + Durations.changeCardAnimation.showNewCardAnimationDuration
        
        runAction(SKAction.waitForDuration(totalDuration), completion: completion)
    }
    
    
    func moveCard(card: Card, completion: () -> ()) {
        var point = pointForPosition(column: card.column, row: card.row)
        moveCard(card, point: point, completion: completion)
    }
    
    func moveCard(card: Card, point: CGPoint, completion: () -> ()) {
        if let sprite = card.sprite {
            let moveAnimation = SKAction.moveTo(point, duration: Durations.moveCardDuration)
            moveAnimation.timingMode = .EaseOut
            
            sprite.runAction(moveAnimation, completion: completion)
        }
    }
    
    func swapCards(card1: Card, _ card2: Card, completion: () -> ()) {
        self.moveCard(card1) {}
        self.moveCard(card2) {}
        
        runAction(SKAction.waitForDuration(Durations.moveCardDuration), completion: completion)
    }
    
    func removeCards(cards: [Card], completion: () -> ()) {
        for card in cards {
            if let sprite = card.sprite {
                let removeAnimation = SKAction.scaleTo(0, duration: Durations.removeCardDuration)
                removeAnimation.timingMode = .EaseOut
                sprite.runAction(SKAction.sequence([removeAnimation, SKAction.removeFromParent()]))
            }
        }
        
        runAction(SKAction.waitForDuration(Durations.removeCardDuration), completion: completion)
    }
    
    func fallCards(cards: [Card], completion: () -> ()) {
        for card in cards {
            if let sprite = card.sprite {
                var point = pointForPosition(column: card.column, row: card.row)
                let fallAnimation = SKAction.moveTo(point, duration: Durations.fallCardDuration)
                fallAnimation.timingMode = .EaseOut
                sprite.runAction(fallAnimation)
            }
        }
        
        runAction(SKAction.waitForDuration(Durations.fallCardDuration), completion: completion)
    }
    
    
    
    
    func resetScene(cards: [Card?]) {
        for card in cards {
            if let sprite = card?.sprite {
                sprite.removeFromParent()
            }
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    func showCombo(combo: Int) {
        var rect = SKShapeNode(rectOfSize: self.size)
        rect.fillColor = Colors.comboBackgroundColor
        rect.alpha = 0
        rect.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        var label = SKLabelNode(text: "Combo X\(combo)")
        label.fontName = "Chalkduster"
        label.fontSize = 50
        label.fontColor = Colors.comboTextColor
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        label.zPosition = 10
        label.alpha = 0
        
        gameBoardLayer.addChild(label)
        gameBoardLayer.addChild(rect)
        
        let showAnimation = {(node: SKNode, alpha: CGFloat) -> () in
            var showRectAnimation = SKAction.fadeAlphaTo(alpha, duration: Durations.comboAnimation.showComboAnimationDuration)
            showRectAnimation.timingMode = .EaseOut
            var waitRectAnimation = SKAction.waitForDuration(Durations.comboAnimation.waitComboAnimationDuration)
            waitRectAnimation.timingMode = .EaseOut
            var hideRectAnimation = SKAction.fadeAlphaTo(0, duration: Durations.comboAnimation.hideComboAnimationDuration)
            hideRectAnimation.timingMode = .EaseOut
            
            node.runAction(SKAction.sequence([showRectAnimation, waitRectAnimation, hideRectAnimation])) {
                rect.removeFromParent()
            }
        }
        
        showAnimation(rect, 0.9)
        showAnimation(label, 1.0)
    }
    
    
    
    
    
    
    private func createSpriteForCard(card: Card) -> SKSpriteNode {
        var texture = self.textureCache[card.spriteName]
        if texture == nil {
            texture = SKTexture(imageNamed: card.spriteName)
            self.textureCache[card.spriteName] = texture
        }
        
        let spriteSize = CGSize(width: CardWidth, height: CardHeight)
        let sprite = SKSpriteNode(color: Colors.transparent, size: spriteSize)
      
        var rectSize = CGSize(width: sprite.size.width - 10, height: sprite.size.height - 10)
        var rect = SKSpriteNode(texture: texture, size: rectSize)
        sprite.addChild(rect)
    
        //let sprite = SKSpriteNode(texture: texture, size: spriteSize)
        sprite.position = pointForPosition(column: card.column, row: card.row)
        
        return sprite
    }
}
