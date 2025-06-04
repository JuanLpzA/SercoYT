document.addEventListener('DOMContentLoaded', () => {
    // --- DOM Element Selectors ---
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    const mobileToggle = document.getElementById('mobileToggle');
    const mainContent = document.querySelector('.main-content');

    const userMenu = document.getElementById('userMenu');
    const dropdownMenu = document.getElementById('dropdownMenu');

    const menuItems = document.querySelectorAll('.sidebar .menu-item');
    const contentSections = document.querySelectorAll('.content-area .content-section');
    const pageTitleElement = document.getElementById('pageTitle');

    // Modals
    const newClientModal = document.getElementById('newClientModal');
    const openNewClientModalBtnVender = document.getElementById('newClientBtn'); // El botón en la sección vender
    const closeClientModalBtn = document.getElementById('closeClientModal');
    const cancelClientBtn = document.getElementById('cancelClientBtn');
    const newClientForm = document.getElementById('newClientForm');

    const productModal = document.getElementById('productModal');
    const addProductBtn = document.getElementById('addProductBtn');
    const closeProductModalBtn = document.getElementById('closeProductModal');
    const cancelProductBtn = document.getElementById('cancelProductBtn');
    const productForm = document.getElementById('productForm');
    const productModalTitle = document.getElementById('productModalTitle');
    const productIdField = document.getElementById('productId');

    // Report Tabs
    const reportsTabsContainer = document.querySelector('.reports-tabs');
    const tabBtns = document.querySelectorAll('.reports-tabs .tab-btn');
    const tabContents = document.querySelectorAll('.content-area #reportes-section .tab-content');

    // Dashboard Stats
    const totalProductsEl = document.getElementById('totalProducts');
    const totalSalesEl = document.getElementById('totalSales');
    const totalClientsEl = document.getElementById('totalClients');
    const monthlyRevenueEl = document.getElementById('monthlyRevenue');
    const topProductsEl = document.getElementById('topProducts');

    // "Vender" Section Elements
    const clientDniInput = document.getElementById('clientDni');
    const searchClientBtn = document.getElementById('searchClientBtn');
    const clientInfoDiv = document.getElementById('clientInfo');
    const clientNameSpan = document.getElementById('clientName');
    const clientPhoneSpan = document.getElementById('clientPhone');
    const newClientBtnVender = document.getElementById('newClientBtn'); // Ya seleccionado arriba
    const productsListVender = document.getElementById('productsList');
    const saleItemsList = document.getElementById('saleItems');
    const subtotalEl = document.getElementById('subtotal');
    const igvEl = document.getElementById('igv');
    const totalEl = document.getElementById('total');
    const completeSaleBtn = document.getElementById('completeSaleBtn');
    const newSaleBtn = document.getElementById('newSaleBtn');

    // "Productos" Section Elements
    const productsTableBody = document.getElementById('productsTableBody');
    const categoryFilter = document.getElementById('categoryFilter');
    const brandFilter = document.getElementById('brandFilter');
    const productCategorySelect = document.getElementById('productCategory');
    const productBrandSelect = document.getElementById('productBrand');


    // "Clientes" Section Elements
    const clientsTableBody = document.getElementById('clientsTableBody');

    // "Reportes" Section Elements
    const presencialReportsBody = document.getElementById('presencialReportsBody');
    const virtualReportsBody = document.getElementById('virtualReportsBody');

    // "Cuentas" Section Elements
    const accountsTableBody = document.getElementById('accountsTableBody');

    // "Estadísticas" Section Elements
    const lowStockProductsEl = document.getElementById('lowStockProducts');

    // "Notificaciones" Section Elements
    const notificationsListEl = document.getElementById('notificationsList');
    const stockNotifBadge = document.getElementById('stockNotifBadge');
    const generalNotificationCount = document.getElementById('notificationCount');
    const markAllReadBtn = document.getElementById('markAllReadBtn');


    // --- State Variables ---
    let currentSaleItems = [];
    let nextSaleItemId = 1;
    const IGV_RATE = 0.18;
    let charts = {}; // To store chart instances

    // --- Utility Functions ---
    function showModal(modalElement) {
        modalElement.classList.add('active');
        modalElement.style.display = 'flex'; // Ensure it's flex for centering
    }

    function hideModal(modalElement) {
        modalElement.classList.remove('active');
        modalElement.style.display = 'none';
    }

    function updatePageTitle(title) {
        pageTitleElement.textContent = title;
        document.title = `SercoYT - ${title}`;
    }

    function showSweetAlert(title, text, icon = 'success', timer = 2000) {
        swal({
            title: title,
            text: text,
            icon: icon,
            timer: timer,
            buttons: false,
        });
    }


    // --- Sidebar Logic ---
    function initSidebar() {
        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', () => {
                sidebar.classList.toggle('collapsed');
                // Recalcular gráficos si están visibles y el sidebar cambia de tamaño
                if (sidebar.classList.contains('collapsed') || !sidebar.classList.contains('collapsed')) {
                    setTimeout(resizeCharts, 350); // Coincidir con transición CSS
                }
            });
        }

        if (mobileToggle) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('open');
            });
        }

        // Close mobile sidebar when clicking a menu item
        menuItems.forEach(item => {
            item.querySelector('a').addEventListener('click', () => {
                if (window.innerWidth <= 992 && sidebar.classList.contains('open')) {
                    sidebar.classList.remove('open');
                }
            });
        });

        // Close mobile sidebar when clicking on main content (optional)
        mainContent.addEventListener('click', () => {
            if (window.innerWidth <= 992 && sidebar.classList.contains('open')) {
                sidebar.classList.remove('open');
            }
        });
    }

    // --- User Menu Logic ---
    function initUserMenu() {
        if (userMenu) {
            userMenu.addEventListener('click', (event) => {
                event.stopPropagation(); // Evita que el click se propague al window
                userMenu.classList.toggle('open');
                dropdownMenu.style.display = userMenu.classList.contains('open') ? 'block' : 'none';
            });
        }
        // Close dropdown if clicked outside
        window.addEventListener('click', (event) => {
            if (userMenu && userMenu.classList.contains('open') && !userMenu.contains(event.target)) {
                userMenu.classList.remove('open');
                dropdownMenu.style.display = 'none';
            }
        });
    }

    // --- Navigation Logic ---
    function initNavigation() {
        menuItems.forEach(item => {
            const link = item.querySelector('a');
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const sectionId = item.dataset.section;
                setActiveSection(sectionId);

                // Guardar la sección activa en localStorage
                localStorage.setItem('activeAdminSection', sectionId);
            });
        });

        // Cargar la sección activa desde localStorage o default a 'dashboard'
        const savedSection = localStorage.getItem('activeAdminSection');
        if (savedSection) {
            setActiveSection(savedSection);
        } else {
            setActiveSection('dashboard');
        }
    }

    function setActiveSection(sectionId) {
        menuItems.forEach(item => {
            item.classList.toggle('active', item.dataset.section === sectionId);
        });
        contentSections.forEach(section => {
            section.classList.toggle('active', section.id === `${sectionId}-section`);
        });

        const activeMenuItem = document.querySelector(`.menu-item[data-section="${sectionId}"] .menu-link span`);
        updatePageTitle(activeMenuItem ? activeMenuItem.textContent : 'Dashboard');

        // Si la sección es 'dashboard' o 'estadisticas', (re)inicializar/actualizar gráficos
        if ((sectionId === 'dashboard' || sectionId === 'estadisticas') && contentSections[0].classList.contains('active')) {
            loadDashboardData(); // Esto también inicializará los gráficos del dashboard
            if (sectionId === 'estadisticas')
                initStatisticsCharts();
            resizeCharts();
        }
    }

    // --- Modal Logic ---
    function initModals() {
        // New Client Modal (Vender)
        if (openNewClientModalBtnVender) {
            openNewClientModalBtnVender.addEventListener('click', () => {
                newClientForm.reset();
                clientDniInput.value = ''; // Limpiar DNI de búsqueda
                clientInfoDiv.style.display = 'none';
                showModal(newClientModal);
            });
        }
        if (closeClientModalBtn)
            closeClientModalBtn.addEventListener('click', () => hideModal(newClientModal));
        if (cancelClientBtn)
            cancelClientBtn.addEventListener('click', () => hideModal(newClientModal));
        if (newClientForm) {
            newClientForm.addEventListener('submit', (e) => {
                e.preventDefault();
                // Aquí iría la lógica para guardar el cliente (AJAX)
                const formData = new FormData(newClientForm);
                const clientData = Object.fromEntries(formData.entries());
                console.log('Nuevo Cliente:', clientData);
                showSweetAlert('Cliente Registrado', `${clientData.nombre} ${clientData.apellido} ha sido registrado.`);
                hideModal(newClientModal);
                // Simular que se encontró el cliente y llenar la info en "Vender"
                clientNameSpan.textContent = `${clientData.nombre} ${clientData.apellido}`;
                clientPhoneSpan.textContent = clientData.telefono || 'N/A';
                clientInfoDiv.style.display = 'block';
                newClientBtnVender.style.display = 'none';
            });
        }

        // Product Modal
        if (addProductBtn) {
            addProductBtn.addEventListener('click', () => openProductModal());
        }
        if (closeProductModalBtn)
            closeProductModalBtn.addEventListener('click', () => hideModal(productModal));
        if (cancelProductBtn)
            cancelProductBtn.addEventListener('click', () => hideModal(productModal));

        if (productForm) {
            productForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const formData = new FormData(productForm);
                // Por alguna razón, Object.fromEntries(formData.entries()) no siempre funciona bien con File inputs
                // Es mejor enviar formData directamente si hay un archivo, o procesarlo manualmente.
                const productData = {
                    idProducto: formData.get('idProducto'),
                    nombre: formData.get('nombre'),
                    precio: formData.get('precio'),
                    descripcion: formData.get('descripcion'),
                    idCategoria: formData.get('idCategoria'),
                    idMarca: formData.get('idMarca'),
                    stock: formData.get('stock'),
                    // imagen: formData.get('imagen') // El archivo en sí
                };
                console.log('Datos Producto:', productData);
                const action = productData.idProducto ? 'actualizado' : 'agregado';
                showSweetAlert('Producto Guardado', `El producto ha sido ${action} correctamente.`);
                hideModal(productModal);
                loadProductsTable(); // Recargar tabla de productos
            });
        }

        // Cerrar modales al hacer clic fuera del contenido del modal
        window.addEventListener('click', (event) => {
            if (event.target === newClientModal)
                hideModal(newClientModal);
            if (event.target === productModal)
                hideModal(productModal);
        });
    }

    function openProductModal(product = null) {
        productForm.reset();
        if (product) {
            productModalTitle.textContent = 'Editar Producto';
            productIdField.value = product.id;
            document.getElementById('productName').value = product.nombre;
            document.getElementById('productPrice').value = product.precio;
            document.getElementById('productDescription').value = product.descripcion;
            document.getElementById('productCategory').value = product.idCategoria;
            document.getElementById('productBrand').value = product.idMarca;
            document.getElementById('productStock').value = product.stock;
            // Manejar la imagen si existe
        } else {
            productModalTitle.textContent = 'Agregar Producto';
            productIdField.value = '';
        }
        // Cargar categorías y marcas en los selects del modal (simulado)
        populateProductModalSelects();
        showModal(productModal);
    }

    function populateProductModalSelects() {
        // Simulación de carga de categorías y marcas
        const categories = [
            {id: 1, nombre: 'Electrónicos'}, {id: 2, nombre: 'Ropa'}, {id: 3, nombre: 'Hogar'}
        ];
        const brands = [
            {id: 1, nombre: 'Sony'}, {id: 2, nombre: 'Samsung'}, {id: 3, nombre: 'Nike'}
        ];

        productCategorySelect.innerHTML = '<option value="">Seleccionar categoría</option>';
        categories.forEach(cat => productCategorySelect.innerHTML += `<option value="${cat.id}">${cat.nombre}</option>`);

        productBrandSelect.innerHTML = '<option value="">Seleccionar marca</option>';
        brands.forEach(brand => productBrandSelect.innerHTML += `<option value="${brand.id}">${brand.nombre}</option>`);
    }


    // --- Report Tabs Logic ---
    function initReportTabs() {
        if (reportsTabsContainer) { // Asegurarse que estamos en la sección de reportes
            tabBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    const targetTabId = btn.dataset.tab;

                    tabBtns.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');

                    tabContents.forEach(content => {
                        content.classList.toggle('active', content.id === `${targetTabId}-tab`);
                    });
                });
            });
            // Activar la primera pestaña por defecto si existe
            if (tabBtns.length > 0) {
                tabBtns[0].click();
            }
        }
    }


    // --- Chart.js Functions ---
    function createOrUpdateChart(canvasId, type, data, options) {
        const ctx = document.getElementById(canvasId)?.getContext('2d');
        if (!ctx)
            return;

        if (charts[canvasId]) {
            charts[canvasId].destroy();
        }
        charts[canvasId] = new Chart(ctx, {type, data, options});
    }

    function resizeCharts() {
        for (const chartId in charts) {
            if (charts[chartId] && typeof charts[chartId].resize === 'function') {
                charts[chartId].resize();
            }
        }
    }

    window.addEventListener('resize', resizeCharts);


    // --- Dashboard Data & Charts (Simulated) ---
    function loadDashboardData() {
        if (!totalProductsEl)
            return; // Si no estamos en el dashboard, salir

        // Simular carga de datos
        totalProductsEl.textContent = '1,258';
        totalSalesEl.textContent = '302';
        totalClientsEl.textContent = '87';
        monthlyRevenueEl.textContent = 'S/. 12,450.00';

        // Top Productos
        const topProds = [
            {name: 'Laptop Gamer XYZ', sales: 150},
            {name: 'Mouse Ergonómico', sales: 120},
            {name: 'Teclado Mecánico RGB', sales: 95},
            {name: 'Monitor Curvo 27"', sales: 70},
        ];
        topProductsEl.innerHTML = topProds.map(p => `
            <div class="list-item animate__animated animate__fadeInUp">
                <span class="item-name">${p.name}</span>
                <span class="item-value">${p.sales} ventas</span>
            </div>
        `).join('');

        initDashboardCharts();
    }

    function initDashboardCharts() {
        // Sales Chart (Ventas por Mes)
        const salesChartData = {
            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago'],
            datasets: [{
                    label: 'Ventas 2024',
                    data: [650, 590, 800, 810, 560, 550, 720, 900],
                    borderColor: 'rgba(135, 206, 250, 1)', // Celeste principal
                    backgroundColor: 'rgba(135, 206, 250, 0.2)',
                    tension: 0.3,
                    fill: true,
                }, {
                    label: 'Ventas 2023 (anterior)',
                    data: [280, 480, 400, 190, 860, 270, 900, 750],
                    borderColor: 'rgba(192, 192, 192, 1)', // Gris
                    backgroundColor: 'rgba(192, 192, 192, 0.2)',
                    tension: 0.3,
                    fill: true,
                }]
        };
        createOrUpdateChart('salesChart', 'line', salesChartData, {responsive: true, maintainAspectRatio: false});
    }


    // --- "Vender" 
    function initVenderSection() {
        if (!clientDniInput)
            return; // Salir si no estamos en la sección

        searchClientBtn.addEventListener('click', () => {
            const dni = clientDniInput.value.trim();
            if (dni) {
                // Simular búsqueda de cliente
                console.log('Buscando cliente DNI:', dni);
                if (dni === "12345678") { // Cliente de ejemplo
                    clientNameSpan.textContent = "Juan Pérez";
                    clientPhoneSpan.textContent = "987654321";
                    clientInfoDiv.style.display = 'block';
                    newClientBtnVender.style.display = 'none';
                } else {
                    clientInfoDiv.style.display = 'none';
                    newClientBtnVender.style.display = 'inline-block';
                    showSweetAlert('Cliente no encontrado', 'Puede registrarlo como nuevo cliente.', 'info', 2500);
                }
            }
        });

        loadProductsForSale(); // Cargar productos disponibles para la venta

        completeSaleBtn.addEventListener('click', () => {
            if (currentSaleItems.length === 0) {
                showSweetAlert('Venta Vacía', 'Agregue productos antes de completar la venta.', 'warning');
                return;
            }
            // Aquí iría la lógica para procesar la venta (AJAX)
            console.log('Venta completada:', currentSaleItems);
            const totalAmount = parseFloat(totalEl.textContent.replace('S/. ', ''));
            showSweetAlert('Venta Realizada', `Se ha completado la venta por un total de S/. ${totalAmount.toFixed(2)}`);
            resetSale();
        });

        newSaleBtn.addEventListener('click', resetSale);
    }

    function loadProductsForSale(filter = '') {
        if (!productsListVender)
            return;
        // Simular carga de productos
        const allProducts = [
            {id: 1, nombre: 'Laptop Pro', precio: 3500, stock: 10, imagen: 'img/laptop.jpg'},
            {id: 2, nombre: 'Mouse Gamer', precio: 150, stock: 25, imagen: 'img/mouse.jpg'},
            {id: 3, nombre: 'Teclado RGB', precio: 280, stock: 15, imagen: 'img/keyboard.jpg'},
            {id: 4, nombre: 'Monitor 24"', precio: 750, stock: 8, imagen: 'img/monitor.jpg'},
            {id: 5, nombre: 'Webcam HD', precio: 120, stock: 30, imagen: 'img/webcam.jpg'},
        ];
        const filteredProducts = allProducts.filter(p => p.nombre.toLowerCase().includes(filter.toLowerCase()));

        productsListVender.innerHTML = filteredProducts.map(p => `
            <div class="product-card-sale animate__animated animate__fadeIn" data-product-id="${p.id}">
                <img src="${p.imagen}" alt="${p.nombre}" onerror="this.src='img/placeholder.png'">
                <h4>${p.nombre}</h4>
                <p>S/. ${p.precio.toFixed(2)}</p>
                <small>Stock: ${p.stock}</small>
            </div>
        `).join('');

        // Add event listeners to new product cards
        document.querySelectorAll('.product-card-sale').forEach(card => {
            card.addEventListener('click', () => {
                const productId = parseInt(card.dataset.productId);
                const product = allProducts.find(p => p.id === productId);
                if (product && product.stock > 0) {
                    addProductToSale(product);
                } else {
                    showSweetAlert('Sin Stock', 'Este producto no tiene stock disponible.', 'error', 1500);
                }
            });
        });
    }
    // Para búsqueda en tiempo real (ejemplo)
    const productSearchInput = document.getElementById('productSearch');
    if (productSearchInput) {
        productSearchInput.addEventListener('input', (e) => loadProductsForSale(e.target.value));
    }


    function addProductToSale(product) {
        const existingItem = currentSaleItems.find(item => item.id === product.id);
        if (existingItem) {
            if (existingItem.cantidad < product.stock) {
                existingItem.cantidad++;
            } else {
                showSweetAlert('Stock Máximo', `No puede agregar más de ${product.stock} unidades.`, 'warning', 2000);
                return;
            }
        } else {
            currentSaleItems.push({...product, cantidad: 1, saleItemId: nextSaleItemId++});
        }
        updateSaleSummary();
    }

    function removeProductFromSale(saleItemId) {
        currentSaleItems = currentSaleItems.filter(item => item.saleItemId !== saleItemId);
        updateSaleSummary();
    }

    function updateSaleItemQuantity(saleItemId, newQuantity, productStock) {
        const item = currentSaleItems.find(i => i.saleItemId === saleItemId);
        if (item) {
            if (newQuantity > 0 && newQuantity <= productStock) {
                item.cantidad = newQuantity;
            } else if (newQuantity > productStock) {
                item.cantidad = productStock;
                showSweetAlert('Stock Máximo', `Solo hay ${productStock} unidades disponibles.`, 'warning', 2000);
            } else { // newQuantity <= 0
                removeProductFromSale(saleItemId);
            }
        }
        updateSaleSummary();
    }


    function updateSaleSummary() {
        if (!saleItemsList)
            return;

        saleItemsList.innerHTML = currentSaleItems.map(item => `
            <div class="sale-item animate__animated animate__fadeIn">
                <span>${item.nombre} (S/. ${item.precio.toFixed(2)})</span>
                <input type="number" value="${item.cantidad}" min="1" max="${item.stock}" class="form-control item-qty" style="width: 60px; padding: 5px;" data-sale-item-id="${item.saleItemId}" data-stock="${item.stock}">
                <span>S/. ${(item.precio * item.cantidad).toFixed(2)}</span>
                <button class="btn-remove-item" data-sale-item-id="${item.saleItemId}">&times;</button>
            </div>
        `).join('');

        // Event listeners para cantidades y botones de eliminar
        saleItemsList.querySelectorAll('.item-qty').forEach(input => {
            input.addEventListener('change', (e) => {
                const saleItemId = parseInt(e.target.dataset.saleItemId);
                const stock = parseInt(e.target.dataset.stock);
                updateSaleItemQuantity(saleItemId, parseInt(e.target.value), stock);
            });
        });
        saleItemsList.querySelectorAll('.btn-remove-item').forEach(button => {
            button.addEventListener('click', (e) => {
                removeProductFromSale(parseInt(e.target.dataset.saleItemId));
            });
        });


        const sub = currentSaleItems.reduce((sum, item) => sum + (item.precio * item.cantidad), 0);
        const igv = sub * IGV_RATE;
        const total = sub + igv;

        subtotalEl.textContent = `S/. ${sub.toFixed(2)}`;
        igvEl.textContent = `S/. ${igv.toFixed(2)}`;
        totalEl.textContent = `S/. ${total.toFixed(2)}`;

        completeSaleBtn.disabled = currentSaleItems.length === 0;
    }

    function resetSale() {
        currentSaleItems = [];
        clientDniInput.value = '';
        clientInfoDiv.style.display = 'none';
        newClientBtnVender.style.display = 'none'; // Ocultar botón de nuevo cliente
        if (productSearchInput)
            productSearchInput.value = '';
        loadProductsForSale(); // Recargar lista de productos original
        updateSaleSummary();
        console.log('Nueva venta iniciada.');
    }

    // --- "Productos" Section Logic (Simulated) ---
    function initProductosSection() {
        if (!productsTableBody)
            return; // Salir si no estamos en la sección
        loadProductsTable();
        populateProductFilters(); // Cargar filtros de categoría y marca
    }

    function populateProductFilters() {
        // Simulación
        const categories = [{id: "", nombre: "Todas las Categorías"}, {id: 1, nombre: 'Electrónicos'}, {id: 2, nombre: 'Ropa'}];
        const brands = [{id: "", nombre: "Todas las Marcas"}, {id: 1, nombre: 'Sony'}, {id: 2, nombre: 'Nike'}];

        categoryFilter.innerHTML = categories.map(c => `<option value="${c.id}">${c.nombre}</option>`).join('');
        brandFilter.innerHTML = brands.map(b => `<option value="${b.id}">${b.nombre}</option>`).join('');
    }

    function loadProductsTable(filters = {}) {
        if (!productsTableBody)
            return;
        // Simulación de carga de productos
        const sampleProducts = [
            {id: 1, imagen: 'img/laptop.jpg', nombre: 'Laptop Pro X', categoria: 'Electrónicos', marca: 'TechBrand', precio: 4500.00, stock: 15, estado: 'Activo', descripcion: 'Laptop potente', idCategoria: 1, idMarca: 1},
            {id: 2, imagen: 'img/mouse.jpg', nombre: 'Mouse Gamer Z', categoria: 'Accesorios', marca: 'GameGear', precio: 120.50, stock: 50, estado: 'Activo', descripcion: 'Mouse preciso', idCategoria: 1, idMarca: 2},
            {id: 3, imagen: 'img/keyboard.jpg', nombre: 'Teclado Mecánico K', categoria: 'Accesorios', marca: 'TechBrand', precio: 350.00, stock: 0, estado: 'Inactivo', descripcion: 'Teclado duradero', idCategoria: 1, idMarca: 1},
            {id: 4, imagen: 'img/monitor.jpg', nombre: 'Monitor UltraWide', categoria: 'Monitores', marca: 'ViewMax', precio: 1200.00, stock: 5, estado: 'Activo', descripcion: 'Monitor inmersivo', idCategoria: 1, idMarca: 2},
        ];

        productsTableBody.innerHTML = sampleProducts.map(p => `
            <tr class="animate__animated animate__fadeIn">
                <td>${p.id}</td>
                <td><img src="${p.imagen}" alt="${p.nombre}" class="product-image-table" onerror="this.src='img/placeholder.png'"></td>
                <td>${p.nombre}</td>
                <td>${p.categoria}</td>
                <td>${p.marca}</td>
                <td>S/. ${p.precio.toFixed(2)}</td>
                <td>${p.stock}</td>
                <td><span class="status-badge ${p.estado.toLowerCase() === 'activo' ? 'status-active' : 'status-inactive'}">${p.estado}</span></td>
                <td class="action-buttons">
                    <button class="edit-btn" data-id="${p.id}" title="Editar"><i class="fas fa-edit"></i></button>
                    <button class="delete-btn" data-id="${p.id}" title="Eliminar"><i class="fas fa-trash-alt"></i></button>
                </td>
            </tr>
        `).join('');

        // Add event listeners for edit/delete
        productsTableBody.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const productId = parseInt(btn.dataset.id);
                const product = sampleProducts.find(p => p.id === productId); // En una app real, fetch del backend
                openProductModal(product);
            });
        });
        productsTableBody.querySelectorAll('.delete-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const productId = parseInt(btn.dataset.id);
                swal({
                    title: "¿Está seguro?",
                    text: "Una vez eliminado, no podrá recuperar este producto.",
                    icon: "warning",
                    buttons: ["Cancelar", "Sí, eliminar"],
                    dangerMode: true,
                })
                        .then((willDelete) => {
                            if (willDelete) {
                                // Lógica para eliminar (AJAX)
                                console.log('Eliminar producto ID:', productId);
                                showSweetAlert('Eliminado', 'El producto ha sido eliminado.', 'success');
                                loadProductsTable(); // Recargar
                            }
                        });
            });
        });
    }


    // --- "Clientes" 
    function initClientesSection() {
        if (!clientsTableBody)
            return;
        loadClientsTable();
    }
    function loadClientsTable() {
        if (!clientsTableBody)
            return;
        const sampleClients = [
            {id: 1, nombre: 'Ana', apellido: 'García', dni: '87654321', telefono: '912345678'},
            {id: 2, nombre: 'Carlos', apellido: 'Lopez', dni: '12345670', telefono: '909876543'},
        ];
        clientsTableBody.innerHTML = sampleClients.map(c => `
            <tr class="animate__animated animate__fadeIn">
                <td>${c.id}</td>
                <td>${c.nombre}</td>
                <td>${c.apellido}</td>
                <td>${c.dni}</td>
                <td>${c.telefono || 'N/A'}</td>
                <td class="action-buttons">
                    <button class="edit-btn" data-id="${c.id}" title="Editar"><i class="fas fa-edit"></i></button>
                    <button class="view-btn" data-id="${c.id}" title="Ver Compras"><i class="fas fa-shopping-cart"></i></button>
                </td>
            </tr>
        `).join('');
        // Add event listeners for edit/view (simulated)
        clientsTableBody.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                showSweetAlert('Función Editar', 'Próximamente disponible para clientes.', 'info', 1500);
            });
        });
    }

    // --- Admin Sections ---

    // Reportes (Simulated data)
    function initReportesSection() {
        if (!presencialReportsBody)
            return;
        loadPresencialReports();
        loadVirtualReports();
        initReportTabs(); // Moverlo aquí para que se ejecute solo cuando la sección de reportes exista.
    }
    function loadPresencialReports() {
        if (!presencialReportsBody)
            return;
        const data = [
            {id: 'P001', fecha: '2024-05-20', cliente: 'Juan Pérez', vendedor: 'Admin User', total: 150.00, metodo: 'Efectivo'},
            {id: 'P002', fecha: '2024-05-21', cliente: 'Ana Solis', vendedor: 'Admin User', total: 85.50, metodo: 'Tarjeta'},
        ];
        presencialReportsBody.innerHTML = data.map(r => `
            <tr><td>${r.id}</td><td>${r.fecha}</td><td>${r.cliente}</td><td>${r.vendedor}</td><td>S/. ${r.total.toFixed(2)}</td><td>${r.metodo}</td>
            <td><button class="view-btn" title="Ver Detalle"><i class="fas fa-eye"></i></button></td></tr>
        `).join('');
    }
    function loadVirtualReports() {
        if (!virtualReportsBody)
            return;
        const data = [
            {id: 'V001', fecha: '2024-05-19', cliente: 'Luis Castro', total: 250.00, estado: 'Entregado', direccion: 'Av. Siempreviva 123'},
        ];
        virtualReportsBody.innerHTML = data.map(r => `
            <tr><td>${r.id}</td><td>${r.fecha}</td><td>${r.cliente}</td><td>S/. ${r.total.toFixed(2)}</td><td>${r.estado}</td><td>${r.direccion}</td>
            <td><button class="view-btn" title="Ver Detalle"><i class="fas fa-eye"></i></button></td></tr>
        `).join('');
    }


    // Cuentas (Simulated data)
    function initCuentasSection() {
        if (!accountsTableBody)
            return;
        loadAccountsTable();
    }
    function loadAccountsTable() {
        if (!accountsTableBody)
            return;
        const data = [
            {id: 1, nombre: 'Admin', apellido: 'User', dni: '00000001', correo: 'admin@sercoyt.com', tipo: 'administrador', estado: 'Activo'},
            {id: 2, nombre: 'Vendedor', apellido: 'Uno', dni: '00000002', correo: 'vendedor1@sercoyt.com', tipo: 'vendedor', estado: 'Activo'},
        ];
        accountsTableBody.innerHTML = data.map(acc => `
            <tr><td>${acc.id}</td><td>${acc.nombre}</td><td>${acc.apellido}</td><td>${acc.dni}</td><td>${acc.correo}</td><td>${acc.tipo}</td>
            <td><span class="status-badge ${acc.estado.toLowerCase() === 'activo' ? 'status-active' : 'status-inactive'}">${acc.estado}</span></td>
            <td class="action-buttons"><button class="edit-btn" title="Editar"><i class="fas fa-user-edit"></i></button> <button class="delete-btn" title="Cambiar Estado"><i class="fas fa-toggle-on"></i></button></td></tr>
        `).join('');
    }


    // Estadísticas (Simulated data & charts)
    function initEstadisticasSection() {
        if (!document.getElementById('categoryChart'))
            return; // Salir si no estamos en la sección
        initStatisticsCharts();
        loadLowStockProducts();
    }
    function initStatisticsCharts() {
        // Ventas por Categoría
        const categoryChartData = {
            labels: ['Electrónicos', 'Ropa', 'Hogar', 'Accesorios'],
            datasets: [{
                    label: 'Ventas',
                    data: [300, 150, 220, 180],
                    backgroundColor: ['#87CEFA', '#FFB6C1', '#90EE90', '#FFDAB9'],
                }]
        };
        createOrUpdateChart('categoryChart', 'doughnut', categoryChartData, {responsive: true, maintainAspectRatio: false});

        // Comparativa Mensual (ejemplo: Ingresos vs Gastos)
        const monthlyCompData = {
            labels: ['Ene', 'Feb', 'Mar', 'Abr'],
            datasets: [
                {label: 'Ingresos', data: [5000, 6200, 5800, 7100], backgroundColor: 'rgba(52, 211, 153, 0.7)'},
                {label: 'Gastos', data: [3000, 3500, 3200, 3800], backgroundColor: 'rgba(248, 113, 113, 0.7)'}
            ]
        };
        createOrUpdateChart('monthlyComparisonChart', 'bar', monthlyCompData, {responsive: true, maintainAspectRatio: false});

        // Métodos de Pago
        const paymentMethodsData = {
            labels: ['Efectivo', 'Tarjeta', 'Yape/Plin'],
            datasets: [{
                    label: 'Uso',
                    data: [120, 80, 150],
                    backgroundColor: ['#87CEFA', '#FFDEAD', '#98FB98'],
                }]
        };
        createOrUpdateChart('paymentMethodsChart', 'pie', paymentMethodsData, {responsive: true, maintainAspectRatio: false});
    }

    function loadLowStockProducts() {
        if (!lowStockProductsEl)
            return;
        const data = [
            {nombre: 'Monitor UltraWide', stock: 5},
            {nombre: 'Silla Gamer Ergo', stock: 3},
            {nombre: 'Webcam Pro 4K', stock: 2},
        ];
        lowStockProductsEl.innerHTML = data.map(p => `
            <div class="list-item animate__animated animate__fadeInUp">
                <span class="item-name">${p.nombre}</span>
                <span class="item-value" style="color: #ef4444;">${p.stock} unidades</span>
            </div>
        `).join('');
    }

    // Notificaciones (Simulated)
    function initNotificacionesSection() {
        if (!notificationsListEl)
            return;
        loadNotifications();
        if (markAllReadBtn) {
            markAllReadBtn.addEventListener('click', () => {
                notificationsListEl.querySelectorAll('.notification-item.unread').forEach(item => item.classList.remove('unread'));
                updateNotificationCounts(0);
                showSweetAlert('Notificaciones Leídas', 'Todas las notificaciones han sido marcadas como leídas.', 'success', 1500);
            });
        }
    }
    function loadNotifications() {
        if (!notificationsListEl)
            return;
        const sampleNotifications = [
            {id: 1, text: 'Producto "Teclado K" tiene bajo stock (0 unidades).', timestamp: 'Hace 5 minutos', unread: true},
            {id: 2, text: 'Producto "Monitor UltraWide" tiene bajo stock (5 unidades).', timestamp: 'Hace 1 hora', unread: true},
            {id: 3, text: 'Nueva venta virtual #V001 registrada.', timestamp: 'Hace 3 horas', unread: false},
        ];
        notificationsListEl.innerHTML = sampleNotifications.map(n => `
            <div class="notification-item ${n.unread ? 'unread' : ''} animate__animated animate__fadeInUp" data-id="${n.id}">
                <p>${n.text}</p>
                <span class="timestamp">${n.timestamp}</span>
            </div>
        `).join('');

        const unreadCount = sampleNotifications.filter(n => n.unread).length;
        updateNotificationCounts(unreadCount);

        // Marcar como leída al hacer clic (ejemplo)
        notificationsListEl.querySelectorAll('.notification-item.unread').forEach(item => {
            item.addEventListener('click', () => {
                item.classList.remove('unread');
                const currentUnread = notificationsListEl.querySelectorAll('.notification-item.unread').length;
                updateNotificationCounts(currentUnread);
            });
        });
    }

    function updateNotificationCounts(count) {
        if (stockNotifBadge) {
            stockNotifBadge.textContent = count;
            stockNotifBadge.style.display = count > 0 ? 'inline-block' : 'none';
        }
        if (generalNotificationCount) {
            generalNotificationCount.textContent = count;
            generalNotificationCount.style.display = count > 0 ? 'inline-block' : 'none';
        }
    }


    // --- Main Initialization ---
    function init() {
        initSidebar();
        initUserMenu();
        initNavigation(); // Esto también carga la sección activa inicial
        initModals();

        // Inicializar secciones específicas (los datos se cargan cuando la sección se vuelve activa o aquí si es necesario siempre)
        initVenderSection();
        initProductosSection();
        initClientesSection();
        initReportesSection(); // Esto también inicializa las pestañas de reportes
        initCuentasSection();
        initEstadisticasSection();
        initNotificacionesSection();

        // Cargar datos del dashboard si es la sección inicial (la función setActiveSection se encarga de esto, pero una llamada explícita puede ser útil)
        if (document.getElementById('dashboard-section')?.classList.contains('active')) {
            loadDashboardData();
        }

        console.log('Dashboard JS Inicializado.');
    }

    init();
});