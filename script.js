

class InventorySystem {
    constructor() {
        this.pocketInventory = [];
        this.playerInventory = [];
        this.backpackInventory = [];
        this.otherInventory = [];
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
        const pocketGrid = document.getElementById('pocket-inventory');
        pocketGrid.style.gridTemplateColumns = 'repeat(2, 1fr)';
        for (let i = 0; i < 6; i++) {
            const slot = this.createInventorySlot('pocket', i);
            pocketGrid.appendChild(slot);
        }

        const playerGrid = document.getElementById('player-inventory');
        for (let i = 0; i < 30; i++) {
            const slot = this.createInventorySlot('player', i);
            playerGrid.appendChild(slot);
        }

        const backpackGrid = document.getElementById('backpack-inventory');
        for (let i = 0; i < 30; i++) {
            const slot = this.createInventorySlot('backpack', i);
            backpackGrid.appendChild(slot);
        }

        const otherGrid = document.getElementById('other-inventory');
        for (let i = 0; i < 40; i++) {
            const slot = this.createInventorySlot('other', i);
            otherGrid.appendChild(slot);
        }
    }

    createInventorySlot(type, index) {
        const slot = document.createElement('div');
        slot.className = 'item-slot';
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
            slot.addEventListener('drop', this.handleDrop.bind(this));
            slot.addEventListener('click', this.handleSlotClick.bind(this));
        });
    }

    loadSampleData() {
        this.addItem('pocket', 0, {
            name: 'Keys',
            icon: 'fas fa-key',
            quantity: 1,
            description: 'Vehicle and house keys'
        });

        this.addItem('pocket', 1, {
            name: 'Wallet',
            icon: 'fas fa-wallet',
            quantity: 1,
            description: 'Contains cash and cards'
        });

        this.addItem('player', 0, {
            name: 'Burger',
            icon: 'fas fa-hamburger',
            quantity: 3,
            description: 'A delicious burger that restores health'
        });

        this.addItem('player', 1, {
            name: 'Water Bottle',
            icon: 'fas fa-tint',
            quantity: 2,
            description: 'Fresh water to quench your thirst'
        });

        this.addItem('player', 5, {
            name: 'Phone',
            icon: 'fas fa-mobile-alt',
            quantity: 1,
            description: 'A smartphone for communication'
        });

        this.addItem('backpack', 0, {
            name: 'First Aid Kit',
            icon: 'fas fa-medkit',
            quantity: 2,
            description: 'Emergency medical supplies'
        });

        this.addItem('backpack', 1, {
            name: 'Flashlight',
            icon: 'fas fa-flashlight',
            quantity: 1,
            description: 'Portable light source'
        });

        this.addItem('other', 0, {
            name: 'Energy Drink',
            icon: 'fas fa-battery-full',
            quantity: 10,
            description: 'Restores energy and stamina'
        });

        this.addItem('other', 1, {
            name: 'Snacks',
            icon: 'fas fa-cookie-bite',
            quantity: 15,
            description: 'Various snack foods'
        });
    }

    addItem(inventoryType, slotIndex, item) {
        const inventory = this.getInventory(inventoryType);
        inventory[slotIndex] = item;
        this.refreshInventoryDisplay();
    }

    getInventory(type) {
        switch (type) {
            case 'pocket':
                return this.pocketInventory;
            case 'player':
                return this.playerInventory;
            case 'backpack':
                return this.backpackInventory;
            case 'other':
                return this.otherInventory;
            default:
                return this.playerInventory;
        }
    }

    refreshInventoryDisplay() {
        this.updateInventorySlots('pocket', this.pocketInventory);
        this.updateInventorySlots('player', this.playerInventory);
        this.updateInventorySlots('backpack', this.backpackInventory);
        this.updateInventorySlots('other', this.otherInventory);
    }

    updateInventorySlots(type, inventory) {
        const gridId = type === 'pocket' ? 'pocket-inventory' : 
                      type === 'player' ? 'player-inventory' :
                      type === 'backpack' ? 'backpack-inventory' : 'other-inventory';
        
        const grid = document.getElementById(gridId);
        const slots = grid.querySelectorAll('.item-slot');
        
        slots.forEach((slot, index) => {
            const item = inventory[index];
            slot.innerHTML = '';
            slot.classList.remove('has-item');
            
            if (item) {
                slot.classList.add('has-item');
                
                const itemElement = document.createElement('div');
                itemElement.className = 'inventory-item';
                itemElement.draggable = true;
                itemElement.dataset.item = JSON.stringify(item);
                
                const iconElement = document.createElement('div');
                iconElement.className = 'item-slot-img';
                iconElement.innerHTML = `<i class="${item.icon} item-icon"></i>`;
                
                if (item.quantity > 1) {
                    const quantityElement = document.createElement('div');
                    quantityElement.className = 'item-slot-amount';
                    quantityElement.innerHTML = `<p>${item.quantity}</p>`;
                    itemElement.appendChild(quantityElement);
                }
                
                itemElement.appendChild(iconElement);
                slot.appendChild(itemElement);
                
                itemElement.addEventListener('dragstart', this.handleDragStart.bind(this));
                itemElement.addEventListener('dragend', this.handleDragEnd.bind(this));
            }
        });
    }

    handleDragStart(e) {
        this.draggedItem = {
            element: e.target,
            data: JSON.parse(e.target.dataset.item),
            sourceSlot: e.target.parentElement
        };
        e.target.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
    }

    handleDragEnd(e) {
        e.target.classList.remove('dragging');
        this.draggedItem = null;
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
        const sourceSlot = this.draggedItem.sourceSlot;
        
        if (targetSlot === sourceSlot) return;
        
        const sourceType = sourceSlot.dataset.type;
        const sourceIndex = parseInt(sourceSlot.dataset.index);
        const targetType = targetSlot.dataset.type;
        const targetIndex = parseInt(targetSlot.dataset.index);
        
        const sourceInventory = this.getInventory(sourceType);
        const targetInventory = this.getInventory(targetType);
        
        const itemToMove = sourceInventory[sourceIndex];
        const targetItem = targetInventory[targetIndex];
        
        targetInventory[targetIndex] = itemToMove;
        sourceInventory[sourceIndex] = targetItem;
        
        this.refreshInventoryDisplay();
    }

    handleSlotClick(e) {
        document.querySelectorAll('.item-slot.selected').forEach(slot => {
            slot.classList.remove('selected');
        });
        
        e.currentTarget.classList.add('selected');
        this.selectedSlot = e.currentTarget;
        
        const item = this.getItemInSlot(e.currentTarget);
        if (item) {
            this.showItemInfo(item);
        } else {
            this.hideItemInfo();
        }
    }

    getItemInSlot(slot) {
        const type = slot.dataset.type;
        const index = parseInt(slot.dataset.index);
        const inventory = this.getInventory(type);
        return inventory[index];
    }

    showItemInfo(item) {
        const infoContainer = document.querySelector('.ply-iteminfo-container');
        const titleElement = infoContainer.querySelector('.item-info-title');
        const descriptionElement = infoContainer.querySelector('.item-info-description');
        
        titleElement.textContent = item.name;
        descriptionElement.textContent = item.description;
        
        infoContainer.style.display = 'block';
        infoContainer.style.opacity = '1';
    }

    hideItemInfo() {
        const infoContainer = document.querySelector('.ply-iteminfo-container');
        infoContainer.style.display = 'none';
    }
}

document.addEventListener('DOMContentLoaded', () => {
    new InventorySystem();
});
