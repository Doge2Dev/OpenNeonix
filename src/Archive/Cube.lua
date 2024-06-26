local Cube = {}

function Cube.draw(self)
    love.graphics.rectangle("line", self.x, self.y, 32, 32)
    self.hitboxes["master"]:draw()
    self.hitboxes["spikeBox"]:draw()
    love.graphics.print("JumpForce" .. self.properties.jumpForce, 30, 30)
end

function Cube.update(self, elapsed)
    --if love.keyboard.isDown("space", "z", "up") then
    --end
    self.hitboxes["master"].x, self.hitboxes["master"].y = self.x, self.y
    self.hitboxes["spikeBox"].x, self.hitboxes["spikeBox"].y = self.x + 2, self.y + 2

    if not self.properties.dead then
        if not self.properties.flipped then
            self.properties.gravity = 0.8
        else
            self.properties.gravity = -0.8
        end

        self.properties.xVel = 5.2

        if self.properties.direction == "right" then
            self.x = self.x + self.properties.xVel
        else
            self.x = self.x - self.properties.xVel
        end

        self.hitboxes["master"].last.x, self.hitboxes["master"].last.y = self.x, self.y

        if love.keyboard.isDown("space", "z", "up") then
            if not self.properties.jumping and self.properties.grounded then
                self.properties.jumping = true
                self.properties.grounded = false
                self.properties.falling = true
                if self.properties.flipped then
                    self.properties.yVel = self.properties.jumpForce
                else
                    print("aqui po", -self.properties.jumpForce)
                    self.properties.yVel = -self.properties.jumpForce
                end
            end
        end


        for _, t in ipairs(playMap.assets.elements.hitboxes) do
            if collision.rectRect(self.hitboxes["master"], t) then
                if self.hitboxes["master"].x + self.hitboxes["master"].w >= t.x + t.w then
                    self.xVel = 0
                    self.x = t.x - self.hitboxes["master"].w
                end
                if self.hitboxes["master"].y + self.hitboxes["master"].h >= t.y + t.h then
                    self.properties.yVel = 0
                    self.y = t.y - self.hitboxes["master"].h
                    self.properties.jumping = false
                    self.properties.grounded = true
                    self.properties.falling = false
                end
            end
        end

        if not self.properties.grounded or self.properties.falling or self.properties.jumping then
            self.properties.yVel = self.properties.yVel + self.properties.gravity
            self.y = self.y + self.properties.yVel
        end
    end

end

function Cube.keypressed(self, k)
    if k == "return" or k == "rshift" then
        if self.properties.direction == "right" then
            self.properties.direction = "left"
        else
            self.properties.direction = "right"
        end
    end

    if k == "pageup" then
        self.properties.jumpForce = self.properties.jumpForce + 0.1
    end
    if k == "pagedown" then
        self.properties.jumpForce = self.properties.jumpForce - 0.1
    end
end

return Cube