$(document).ready(function() {
    // New category button
    $('#btnNuevaCategoria').click(function() {
        $('#nuevaCategoriaForm')[0].reset();
        $('#nuevaCategoriaModal').modal('show');
    });

    // Edit category button
    $(document).on('click', '.btn-editar', function () {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.categoria.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                $('#edit_id').val(data.id);
                $('#edit_nombre').val(data.nombre);
                $('#edit_estado').val(data.estado);

                $('#editarCategoriaModal').modal('show');
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Error al cargar la categoría',
                    timer: 3000
                });
            },
            complete: function () {
                $btn.prop('disabled', false);
            }
        });
    });

    // Form validation
    function validateCategoriaForm($form) {
        let isValid = true;
        
        // Clear previous validations
        $form.find('.is-invalid').removeClass('is-invalid');
        $form.find('.invalid-feedback').remove();

        // Validate required fields
        $form.find('[required]').each(function() {
            if (!$(this).val().trim()) {
                markAsInvalid($(this), AppContext.messages.requiredField);
                isValid = false;
            }
        });

        return isValid;
    }

    function markAsInvalid($element, message) {
        $element.addClass('is-invalid');
        $element.after(`<div class="invalid-feedback">${message}</div>`);
    }

    // New category form submission
    $('#nuevaCategoriaForm').submit(function(e) {
        if (!validateCategoriaForm($(this))) {
            e.preventDefault();
            scrollToFirstError();
            return false;
        }
        showButtonLoading($(this).find('[type="submit"]'));
    });

    // Edit category form submission
    $('#editarCategoriaForm').submit(function(e) {
        if (!validateCategoriaForm($(this))) {
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
    $('#filtroForm').submit(function(e) {
        e.preventDefault();
        showLoading();
        
        const $form = $(this);
        const params = $form.serialize();
        window.location.href = AppContext.endpoints.categoria.filter + '&' + params;
    });

    // Reset filters
    $('#btnResetFiltros').click(function() {
        $('#filtroForm')[0].reset();
        showLoading();
        window.location.href = AppContext.endpoints.categoria.list;
    });

    // Activate/deactivate category
    $(document).on('click', '.btn-desactivar, .btn-activar', function() {
        const isActivate = $(this).hasClass('btn-activar');
        const id = $(this).data('id');
        
        Swal.fire({
            title: isActivate ? 'Confirmar Activación' : 'Confirmar Desactivación',
            text: isActivate ? 
                '¿Está seguro que desea activar esta categoría?' : 
                '¿Está seguro que desea desactivar esta categoría?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: isActivate ? '#28a745' : '#dc3545',
            confirmButtonText: isActivate ? 'Activar' : 'Desactivar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                const url = isActivate ? 
                    AppContext.endpoints.categoria.activate + id : 
                    AppContext.endpoints.categoria.deactivate + id;
                window.location.href = url;
            }
        });
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
    $('#nuevaCategoriaModal').on('shown.bs.modal', function() {
        $('#nombre').focus();
    });

    $('.modal').on('hidden.bs.modal', function() {
        $(this).find('form').trigger('reset');
        $(this).find('.is-invalid').removeClass('is-invalid');
        $(this).find('.invalid-feedback').remove();
    });

    // Auto-dismiss alerts
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 5000);

    // Tooltips
    $('[data-toggle="tooltip"], .btn-action').tooltip({
        placement: 'top',
        trigger: 'hover'
    });

    // Hide loading when page fully loads
    $(window).on('load', function() {
        hideLoading();
    });

    function showError(message) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: message,
            timer: 3000
        });
    }
});