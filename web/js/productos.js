/**
 * Productos Management Script
 * Improved version with context from JSP
 */

$(document).ready(function () {
    // Constants from JSP context
    const MAX_IMAGE_SIZE = 2 * 1024 * 1024; // 2MB
    const LOADING_DELAY = 500;

    // Initialize Select2 for filters
    $('.filter-card .select2').select2({
        placeholder: "Seleccione una opción",
        allowClear: true,
        width: '100%'
    });

    // Initialize Select2 for modals with tags for brands
    function initSelect2WithTags(selector) {
        $(selector).select2({
            tags: true,
            placeholder: "Seleccione o escriba una marca",
            allowClear: true,
            createTag: function (params) {
                return {
                    id: params.term,
                    text: params.term,
                    newOption: true
                };
            },
            templateResult: function (data) {
                const $result = $("<span></span>");
                $result.text(data.text);
                if (data.newOption) {
                    $result.append(" <em>(nueva)</em>");
                }
                return $result;
            },
            dropdownParent: $(selector).closest('.modal')
        });
    }

    // Setup file upload with preview
    function setupFileUpload(inputSelector, previewSelector, containerSelector) {
        const $input = $(inputSelector);
        const $preview = $(previewSelector);
        const $container = $(containerSelector);
        const $uploadArea = $input.siblings('.file-upload-area');

        $input.on('change', function (e) {
            if (this.files && this.files[0]) {
                const file = this.files[0];

                // Validate file size
                if (file.size > MAX_IMAGE_SIZE) {
                    showError(AppContext.messages.imageSizeError);
                    resetFileInput($input, $container, $uploadArea);
                    return;
                }

                // Validate file type
                if (!file.type.match('image.*')) {
                    showError(AppContext.messages.imageTypeError);
                    resetFileInput($input, $container, $uploadArea);
                    return;
                }

                // Show preview
                const reader = new FileReader();
                reader.onload = function (e) {
                    $preview.attr('src', e.target.result);
                    $container.show();
                    $uploadArea.addClass('has-file');
                }
                reader.readAsDataURL(file);
            }
        });

        // Handle drag and drop
        $uploadArea.on('dragover', function (e) {
            e.preventDefault();
            $(this).addClass('dragover');
        }).on('dragleave', function () {
            $(this).removeClass('dragover');
        }).on('drop', function (e) {
            e.preventDefault();
            $(this).removeClass('dragover');
            $input[0].files = e.originalEvent.dataTransfer.files;
            $input.trigger('change');
        }).on('click', function () {
            $input.trigger('click');
        });
    }

    function resetFileInput($input, $container, $uploadArea) {
        $input.val('');
        $container.hide();
        $uploadArea.removeClass('has-file');
    }

    function showError(message) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: message,
            timer: 3000
        });
    }

    // Initialize modals
    function initModal(modalId, focusElement = null) {
        destroySelect2InModal(modalId);

        setTimeout(function () {
            if (modalId === '#nuevoProductoModal' || modalId === '#editarProductoModal') {
                initSelect2WithTags(modalId + ' select[name="marca"]');
                $(modalId + ' select[name="categoria"]').select2({
                    placeholder: "Seleccione una categoría",
                    allowClear: true,
                    dropdownParent: $(modalId)
                });
            }

            if (focusElement) {
                $(modalId).find(focusElement).focus();
            }
        }, LOADING_DELAY);
    }

    function destroySelect2InModal(modalId) {
        $(modalId + ' .select2').each(function () {
            if ($(this).hasClass('select2-hidden-accessible')) {
                $(this).select2('destroy');
            }
        });
    }

    // New product button
    $('#btnNuevoProducto').click(function () {
        $('#nuevoProductoForm')[0].reset();
        $('#imagenPreviewContainer').hide();
        $('#nuevoProductoModal').modal('show');
    });

    // Edit product button
    $(document).on('click', '.btn-editar', function () {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.product.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                if (data.error) {
                    showError(data.error);
                    return;
                }

                $('#edit_id').val(data.id);
                $('#edit_nombre').val(data.nombres);
                $('#edit_descripcion').val(data.descripcion);
                $('#edit_precio').val(data.precio);

                // Show current image
                if (data.id) {
                    const imgSrc = AppContext.endpoints.image.get + data.id;
                    $('#imagen-actual').attr('src', imgSrc);
                    $('#imagen-actual-container').show();
                }

                $('#editarProductoModal').modal('show');

                // Set values after modal is shown
                setTimeout(function () {
                    $('#edit_marca').val(data.nombreMarca).trigger('change');
                    $('#edit_categoria').val(data.nombreCategoria).trigger('change');
                }, LOADING_DELAY);
            },
            error: function (xhr) {
                showError(xhr.responseText || 'Error al cargar el producto');
            },
            complete: function () {
                $btn.prop('disabled', false);
            }
        });
    });

    // Handle new brand creation
    $(document).on('select2:select', '#marca, #edit_marca', function (e) {
        if (e.params.data.newOption) {
            const nuevaMarca = e.params.data.text;
            $('#nuevaMarcaNombre').val(nuevaMarca);
            $('#nuevaMarcaModal').data('origin-select', this.id);
            $('#nuevaMarcaModal').modal('show');

            // Revert selection
            $(this).val(null).trigger('change');
        }
    });

    // Create new brand
    $('#nuevaMarcaForm').submit(function (e) {
        e.preventDefault();
        const nombreMarca = $('#nuevaMarcaNombre').val().trim();
        const originSelect = $('#nuevaMarcaModal').data('origin-select');

        if (!nombreMarca)
            return;

        const $btn = $(this).find('[type="submit"]');
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Guardando...');

        $.ajax({
            url: AppContext.endpoints.brand.save,
            type: 'POST',
            data: {
                accion: 'guardar',
                nombre: nombreMarca,
                estado: 'activo'
            },
            success: function (response) {
                if (response.exito) {
                    // Add new brand to selects
                    const newOption = new Option(nombreMarca, nombreMarca, true, true);
                    $(`#${originSelect}`).append(newOption).trigger('change');

                    $('#nuevaMarcaModal').modal('hide');
                    $('#nuevaMarcaForm')[0].reset();
                    showSuccess(AppContext.messages.brandCreated);
                } else {
                    showError(response.error || AppContext.messages.brandError);
                }
            },
            error: function (xhr) {
                showError(xhr.responseText || 'Error en la solicitud');
            },
            complete: function () {
                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Guardar Marca');
            }
        });
    });

    function showSuccess(message) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: message,
            timer: 3000
        });
    }

    // Stock management
    $(document).on('click', '.btn-stock', function () {
        const id = $(this).data('id');
        const stockActual = parseInt($(this).data('stock'));

        $('#stock_id').val(id);
        $('#stock_actual').val(stockActual);
        $('#cantidad').val('');
        $('#stock_nuevo').val(stockActual);

        $('#cantidad').off('input').on('input', function () {
            const cantidad = parseInt($(this).val()) || 0;
            const nuevoStock = stockActual + cantidad;
            $('#stock_nuevo').val(nuevoStock);
        });

        $('#stockModal').modal('show');
    });

    // Activate/deactivate product
    $(document).on('click', '.btn-desactivar, .btn-activar', function () {
        const isActivate = $(this).hasClass('btn-activar');
        const id = $(this).data('id');

        Swal.fire({
            title: isActivate ? 'Confirmar Activación' : 'Confirmar Desactivación',
            text: isActivate ?
                    '¿Está seguro que desea activar este producto?' :
                    '¿Está seguro que desea desactivar este producto?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: isActivate ? '#28a745' : '#dc3545',
            confirmButtonText: isActivate ? 'Activar' : 'Desactivar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                const url = isActivate ?
                        AppContext.endpoints.product.activate + id :
                        AppContext.endpoints.product.deactivate + id;
                window.location.href = url;
            }
        });
    });

    // Form validation
    function validateProductForm($form, isEdit = false) {
        let isValid = true;

        // Clear previous validations
        $form.find('.is-invalid').removeClass('is-invalid');
        $form.find('.invalid-feedback').remove();

        // Validate required fields
        $form.find('[required]').each(function () {
            if (!$(this).val().trim()) {
                markAsInvalid($(this), AppContext.messages.requiredField);
                isValid = false;
            }
        });

        // Validate price
        const precio = parseFloat($form.find('[name="precio"]').val());
        if (precio <= 0) {
            markAsInvalid($form.find('[name="precio"]'), AppContext.messages.invalidPrice);
            isValid = false;
        }

        // Validate image (only for new product)
        if (!isEdit) {
            const imagen = $form.find('[name="imagen"]')[0].files[0];
            if (!imagen) {
                markAsInvalid($form.find('[name="imagen"]'), AppContext.messages.requiredField);
                isValid = false;
            }
        }

        return isValid;
    }

    function markAsInvalid($element, message) {
        $element.addClass('is-invalid');
        $element.after(`<div class="invalid-feedback">${message}</div>`);
    }

    // New product form submission
    $('#nuevoProductoForm').submit(function (e) {
        if (!validateProductForm($(this))) {
            e.preventDefault();
            scrollToFirstError();
            return false;
        }
        showButtonLoading($(this).find('[type="submit"]'));
    });

    // Edit product form submission
    $('#editarProductoForm').submit(function (e) {
        // Validar que si se subió una imagen, tenga el tipo correcto
        const imagenInput = document.getElementById('edit_imagen');
        if (imagenInput.files.length > 0) {
            const file = imagenInput.files[0];
            if (!file.type.match('image.*')) {
                e.preventDefault();
                showError(AppContext.messages.imageTypeError);
                return false;
            }
            if (file.size > MAX_IMAGE_SIZE) {
                e.preventDefault();
                showError(AppContext.messages.imageSizeError);
                return false;
            }
        }

        if (!validateProductForm($(this), true)) {
            e.preventDefault();
            scrollToFirstError();
            return false;
        }
        showButtonLoading($(this).find('[type="submit"]'));
    });

    function scrollToFirstError() {
        const $firstError = $('.is-invalid').first();
        if ($firstError.length) {
            $('html, body').animate({
                scrollTop: $firstError.offset().top - 100
            }, 500);
            $firstError.focus();
        }
    }

    function showButtonLoading($btn) {
        $btn.addClass('btn-loading')
                .prop('disabled', true)
                .html('<i class="fas fa-spinner fa-spin"></i> Procesando...');
    }

    // Filter form
    $('#filtroForm').submit(function (e) {
        e.preventDefault();
        showLoading();

        const $form = $(this);
        const params = $form.serialize();
        window.location.href = AppContext.endpoints.product.filter + '&' + params;
    });

    // Reset filters
    $('#btnResetFiltros').click(function () {
        $('#filtroForm')[0].reset();
        $('.filter-card .select2').val(null).trigger('change');
        showLoading();
        window.location.href = AppContext.path + '/ProductoControlador';
    });

    // Loading overlay
    function showLoading() {
        if ($('.loading-overlay').length === 0) {
            $('body').append(`
                <div class="loading-overlay">
                    <div class="loading-spinner"></div>
                </div>
            `);
        }
    }

    function hideLoading() {
        $('.loading-overlay').remove();
    }

    // Modal events
    $('#nuevoProductoModal').on('shown.bs.modal', function () {
        initModal('#nuevoProductoModal', 'input[name="nombre"]');
    });

    $('#editarProductoModal').on('shown.bs.modal', function () {
        initModal('#editarProductoModal');
    });

    $('.modal').on('hidden.bs.modal', function () {
        destroySelect2InModal(`#${$(this).attr('id')}`);
        $(this).find('form').trigger('reset');
        $(this).find('.image-preview-container').hide();
        $(this).find('.file-upload-area').removeClass('has-file');
    });

    // Initialize file uploads
    setupFileUpload('#imagen', '#imagenPreview', '#imagenPreviewContainer');
    setupFileUpload('#edit_imagen', '#imagen-actual', '#imagen-actual-container');

    // Auto-dismiss alerts
    setTimeout(function () {
        $('.alert').fadeOut();
    }, 5000);

    // Tooltips
    $('[data-toggle="tooltip"], .btn-action').tooltip({
        placement: 'top',
        trigger: 'hover'
    });

    // Hide loading when page fully loads
    $(window).on('load', function () {
        hideLoading();
    });
});