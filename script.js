
class InventorySystem {
    constructor() {
        this.playerInventory = [];
        this.groundInventory = [];
        this.trunkInventory = [];
        this.equipment = {};
        this.selectedSlot = null;
        this.draggedItem = null;
        
        this.init();
    }

    init() {
        this.generateInventorySlots();
        this.setupEventListeners();
        this.loadSampleData();
    }

    generateInventorySlots() {
        const playerGrid = document.getElementById('player-inventory');
        for (let i = 0; i < 40; i++) {
            const slot = this.createInventorySlot('player', i);
            playerGrid.appendChild(slot);
        }

        const groundGrid = document.getElementById('ground-inventory');
        for (let i = 0; i < 20; i++) {
            const slot = this.createInventorySlot('ground', i);
            groundGrid.appendChild(slot);
        }

        const trunkGrid = document.getElementById('trunk-inventory');
        for (let i = 0; i < 20; i++) {
            const slot = this.createInventorySlot('trunk', i);
            trunkGrid.appendChild(slot);
        }
    }

    createInventorySlot(type, index) {
        const slot = document.createElement('div');
        slot.className = 'inventory-slot';
        slot.dataset.type = type;
        slot.dataset.index = index;
        
        slot.addEventListener('dragover', this.handleDragOver.bind(this));
        slot.addEventListener('drop', this.handleDrop.bind(this));
        slot.addEventListener('click', this.handleSlotClick.bind(this));
        
        return slot;
    }

    setupEventListeners() {
        const equipmentSlots = document.querySelectorAll('.equipment-slot');
        equipmentSlots.forEach(slot => {
            slot.addEventListener('dragover', this.handleDragOver.bind(this));
            slot.addEventListener('drop', this.handleEquipmentDrop.bind(this));
            slot.addEventListener('click', this.handleEquipmentClick.bind(this));
        });

        document.addEventListener('keydown', this.handleKeyPress.bind(this));
    }

    loadSampleData() {
        this.addItem('player', 0, {
            id: 'phone',
            name: 'Phone',
            icon: 'fas fa-mobile-alt',
            quantity: 1,
            type: 'electronics'
        });

        this.addItem('player', 1, {
            id: 'wallet',
            name: 'Wallet',
            icon: 'fas fa-wallet',
            quantity: 1,
            type: 'personal'
        });

        this.addItem('player', 2, {
            id: 'keys',
            name: 'Keys',
            icon: 'fas fa-key',
            quantity: 3,
            type: 'tools'
        });

        this.addItem('player', 5, {
            id: 'bandage',
            name: 'Bandage',
            icon: 'fas fa-band-aid',
            quantity: 5,
            type: 'medical'
        });

        this.addItem('ground', 0, {
            id: 'pistol',
            name: 'Pistol',
            icon: 'fas fa-gun',
            quantity: 1,
            type: 'weapon'
        });

        this.addItem('trunk', 0, {
            id: 'laptop',
            name: 'Laptop',
            icon: 'fas fa-laptop',
            quantity: 1,
            type: 'electronics'
        });
    }

    addItem(inventoryType, slotIndex, item) {
        const slot = document.querySelector(`[data-type="${inventoryType}"][data-index="${slotIndex}"]`);
        if (!slot) return;

        switch (inventoryType) {
            case 'player':
                this.playerInventory[slotIndex] = item;
                break;
            case 'ground':
                this.groundInventory[slotIndex] = item;
                break;
            case 'trunk':
                this.trunkInventory[slotIndex] = item;
                break;
        }

        const itemElement = this.createItemElement(item);
        slot.innerHTML = '';
        slot.appendChild(itemElement);
        slot.classList.add('has-item');

        itemElement.draggable = true;
        itemElement.addEventListener('dragstart', this.handleDragStart.bind(this));
        itemElement.addEventListener('dragend', this.handleDragEnd.bind(this));
    }

    createItemElement(item) {
        const itemDiv = document.createElement('div');
        itemDiv.className = 'inventory-item';
        itemDiv.dataset.itemId = item.id;

        const icon = document.createElement('i');
        icon.className = `${item.icon} item-icon`;
        itemDiv.appendChild(icon);

        if (item.quantity > 1) {
            const quantity = document.createElement('span');
            quantity.className = 'item-quantity';
            quantity.textContent = item.quantity;
            itemDiv.appendChild(quantity);
        }

        itemDiv.title = item.name;

        return itemDiv;
    }

    handleDragStart(e) {
        const slot = e.target.closest('.inventory-slot, .equipment-slot');
        this.draggedItem = {
            element: e.target,
            slot: slot,
            type: slot.dataset.type,
            index: slot.dataset.index,
            slotType: slot.dataset.slot
        };
        
        e.target.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
    }

    handleDragEnd(e) {
        e.target.classList.remove('dragging');
        this.draggedItem = null;
        
        document.querySelectorAll('.drag-over').forEach(slot => {
            slot.classList.remove('drag-over');
        });
    }

    handleDragOver(e) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        e.currentTarget.classList.add('drag-over');
    }

    handleDrop(e) {
        e.preventDefault();
        e.currentTarget.classList.remove('drag-over');
        
        if (!this.draggedItem) return;

        const targetSlot = e.currentTarget;
        const targetType = targetSlot.dataset.type;
        const targetIndex = parseInt(targetSlot.dataset.index);

        if (this.draggedItem.slot === targetSlot) return;

        this.moveItem(this.draggedItem, targetType, targetIndex);
    }

    handleEquipmentDrop(e) {
        e.preventDefault();
        e.currentTarget.classList.remove('drag-over');
        
        if (!this.draggedItem) return;

        const targetSlot = e.currentTarget;
        const equipmentType = targetSlot.dataset.slot;

        const item = this.getItemFromSlot(this.draggedItem.slot);
        if (!this.canEquipItem(item, equipmentType)) {
            console.log('Cannot equip this item in this slot');
            return;
        }

        this.equipItem(this.draggedItem, equipmentType);
    }

    moveItem(draggedItem, targetType, targetIndex) {
        const sourceItem = this.getItemFromSlot(draggedItem.slot);
        const targetSlot = document.querySelector(`[data-type="${targetType}"][data-index="${targetIndex}"]`);
        
        if (!sourceItem || !targetSlot) return;

        const targetItem = this.getItemFromInventory(targetType, targetIndex);
        
        if (targetItem) {
            this.swapItems(draggedItem, targetType, targetIndex);
        } else {
            this.removeItemFromSlot(draggedItem.slot);
            this.addItem(targetType, targetIndex, sourceItem);
        }
    }

    swapItems(draggedItem, targetType, targetIndex) {
        const sourceItem = this.getItemFromSlot(draggedItem.slot);
        const targetItem = this.getItemFromInventory(targetType, targetIndex);
        
        this.removeItemFromSlot(draggedItem.slot);
        this.removeItemFromInventory(targetType, targetIndex);
        
        this.addItem(targetType, targetIndex, sourceItem);
        this.addItem(draggedItem.type, parseInt(draggedItem.index), targetItem);
    }

    equipItem(draggedItem, equipmentType) {
        const item = this.getItemFromSlot(draggedItem.slot);
        if (!item) return;

        this.removeItemFromSlot(draggedItem.slot);
        
        this.equipment[equipmentType] = item;
        
        const equipmentSlot = document.querySelector(`[data-slot="${equipmentType}"]`);
        const itemElement = this.createItemElement(item);
        equipmentSlot.innerHTML = '';
        equipmentSlot.appendChild(itemElement);
        equipmentSlot.classList.add('has-item');
        
        itemElement.draggable = true;
        itemElement.addEventListener('dragstart', this.handleDragStart.bind(this));
        itemElement.addEventListener('dragend', this.handleDragEnd.bind(this));
    }

    canEquipItem(item, equipmentType) {
        if (!item) return false;
        
        const equipmentRules = {
            'headphones': ['headphones', 'electronics'],
            'mask': ['mask', 'clothing'],
            'glasses': ['glasses', 'clothing'],
            'vest': ['vest', 'armor', 'clothing'],
            'shoes': ['shoes', 'clothing'],
            'wallet': ['wallet', 'personal'],
            'phone': ['phone', 'electronics'],
            'keys': ['keys', 'tools'],
            'credit-card': ['credit-card', 'personal'],
            'backpack': ['backpack', 'storage']
        };
        
        const allowedTypes = equipmentRules[equipmentType] || [];
        return allowedTypes.includes(item.id) || allowedTypes.includes(item.type);
    }

    getItemFromSlot(slot) {
        const type = slot.dataset.type;
        const index = parseInt(slot.dataset.index);
        
        if (slot.classList.contains('equipment-slot')) {
            const equipmentType = slot.dataset.slot;
            return this.equipment[equipmentType];
        }
        
        return this.getItemFromInventory(type, index);
    }

    getItemFromInventory(type, index) {
        switch (type) {
            case 'player':
                return this.playerInventory[index];
            case 'ground':
                return this.groundInventory[index];
            case 'trunk':
                return this.trunkInventory[index];
            default:
                return null;
        }
    }

    removeItemFromSlot(slot) {
        const type = slot.dataset.type;
        const index = parseInt(slot.dataset.index);
        
        if (slot.classList.contains('equipment-slot')) {
            const equipmentType = slot.dataset.slot;
            delete this.equipment[equipmentType];
        } else {
            this.removeItemFromInventory(type, index);
        }
        
        slot.innerHTML = '';
        slot.classList.remove('has-item');
    }

    removeItemFromInventory(type, index) {
        switch (type) {
            case 'player':
                delete this.playerInventory[index];
                break;
            case 'ground':
                delete this.groundInventory[index];
                break;
            case 'trunk':
                delete this.trunkInventory[index];
                break;
        }
    }

    handleSlotClick(e) {
        const slot = e.currentTarget;
        
        if (this.selectedSlot) {
            this.selectedSlot.classList.remove('selected');
        }
        
        this.selectedSlot = slot;
        slot.classList.add('selected');
    }

    handleEquipmentClick(e) {
        const slot = e.currentTarget;
        
        if (this.selectedSlot) {
            this.selectedSlot.classList.remove('selected');
        }
        
        this.selectedSlot = slot;
        slot.classList.add('selected');
    }

    handleKeyPress(e) {
        if (e.key === 'Escape') {
            if (this.selectedSlot) {
                this.selectedSlot.classList.remove('selected');
                this.selectedSlot = null;
            }
        }
        
        if (e.key === 'Delete' && this.selectedSlot) {
            this.removeItemFromSlot(this.selectedSlot);
            this.selectedSlot.classList.remove('selected');
            this.selectedSlot = null;
        }
    }

    addItemToPlayer(item) {
        const emptySlot = this.findEmptySlot('player');
        if (emptySlot !== -1) {
            this.addItem('player', emptySlot, item);
            return true;
        }
        return false;
    }

    addItemToGround(item) {
        const emptySlot = this.findEmptySlot('ground');
        if (emptySlot !== -1) {
            this.addItem('ground', emptySlot, item);
            return true;
        }
        return false;
    }

    addItemToTrunk(item) {
        const emptySlot = this.findEmptySlot('trunk');
        if (emptySlot !== -1) {
            this.addItem('trunk', emptySlot, item);
            return true;
        }
        return false;
    }

    findEmptySlot(inventoryType) {
        const inventory = this.getInventoryArray(inventoryType);
        for (let i = 0; i < inventory.length; i++) {
            if (!inventory[i]) {
                return i;
            }
        }
        return -1;
    }

    getInventoryArray(type) {
        switch (type) {
            case 'player':
                return this.playerInventory;
            case 'ground':
                return this.groundInventory;
            case 'trunk':
                return this.trunkInventory;
            default:
                return [];
        }
    }

    exportInventory() {
        return {
            player: this.playerInventory,
            ground: this.groundInventory,
            trunk: this.trunkInventory,
            equipment: this.equipment
        };
    }

    importInventory(data) {
        this.playerInventory = data.player || [];
        this.groundInventory = data.ground || [];
        this.trunkInventory = data.trunk || [];
        this.equipment = data.equipment || {};
        
        this.refreshDisplay();
    }

    refreshDisplay() {
        document.querySelectorAll('.inventory-slot, .equipment-slot').forEach(slot => {
            slot.innerHTML = '';
            slot.classList.remove('has-item');
        });
        
        this.playerInventory.forEach((item, index) => {
            if (item) this.addItem('player', index, item);
        });
        
        this.groundInventory.forEach((item, index) => {
            if (item) this.addItem('ground', index, item);
        });
        
        this.trunkInventory.forEach((item, index) => {
            if (item) this.addItem('trunk', index, item);
        });
        
        Object.entries(this.equipment).forEach(([slot, item]) => {
            if (item) this.equipItem({ slot: document.querySelector(`[data-slot="${slot}"]`) }, slot);
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    window.inventorySystem = new InventorySystem();
    
    window.addTestItem = (type = 'player') => {
        const testItems = [
            { id: 'apple', name: 'Apple', icon: 'fas fa-apple-alt', quantity: 1, type: 'food' },
            { id: 'water', name: 'Water', icon: 'fas fa-tint', quantity: 1, type: 'drink' },
            { id: 'money', name: 'Cash', icon: 'fas fa-dollar-sign', quantity: 100, type: 'currency' },
            { id: 'radio', name: 'Radio', icon: 'fas fa-broadcast-tower', quantity: 1, type: 'electronics' }
        ];
        
        const randomItem = testItems[Math.floor(Math.random() * testItems.length)];
        
        switch (type) {
            case 'player':
                window.inventorySystem.addItemToPlayer(randomItem);
                break;
            case 'ground':
                window.inventorySystem.addItemToGround(randomItem);
                break;
            case 'trunk':
                window.inventorySystem.addItemToTrunk(randomItem);
                break;
        }
    };
    
    console.log('NoPixel Inventory System initialized!');
    console.log('Try: addTestItem("player"), addTestItem("ground"), or addTestItem("trunk")');
});
