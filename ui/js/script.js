window.addEventListener('message', function(event) {
    if (event.data.type === "ui") {
        if (event.data.status) {
            document.getElementById("tabletUI").style.display = "block";
            loadApps();
        } else {
            document.getElementById("tabletUI").style.display = "none";
        }
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(resp => {
            document.getElementById("tabletUI").style.display = 'none';
        });
    }
});

function loadApps() {
    const appsContainer = document.querySelector('.apps');
    appsContainer.innerHTML = '';

    Config.Vehicles.forEach(vehicle => {
        const button = document.createElement('button');
        button.classList.add('app');
        button.id = vehicle.name;
        button.innerHTML = `
            <img src="img/${vehicle.spawnName}.png" alt="${vehicle.name}">
            <span>${vehicle.name} ${vehicle.price}</span>
        `;
        button.addEventListener('click', function() {
            fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({ vehicle: vehicle.name })
            });
        });
        appsContainer.appendChild(button);
    });
}

function updateTimeAndDate() {
    const now = new Date();
    const time = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const date = now.toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    document.getElementById('time').textContent = time;
    document.getElementById('date').textContent = date;
}

setInterval(updateTimeAndDate, 1000);
updateTimeAndDate();
