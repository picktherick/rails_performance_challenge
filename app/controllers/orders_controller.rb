class OrdersController < ApplicationController
  # PROBLEMA: N+1 - não usa includes/eager_load
  def index
    @orders = Order.all
    # Na view, cada acesso a order.product causa uma query
  end

  def show
    @order = Order.find(params[:id])
  end

  # PROBLEMA: Carrega todos os dados sem paginação
  def report
    @report = Order.generate_report
  end

  # PROBLEMA: Múltiplas queries
  def summary
    @summary = Order.orders_summary_by_status
  end

  # PROBLEMA: Query lenta sem índice
  def search
    @orders = Order.search_by_customer(params[:email])
  end

  # PROBLEMA: Busca ineficiente por data
  def by_date_range
    @orders = Order.find_by_date_range(params[:start_date], params[:end_date])
  end

  # PROBLEMA: Cálculo poderia ser feito no banco
  def daily_revenue
    @revenue = Order.calculate_daily_revenue(params[:date])
  end

  # PROBLEMA: Ineficiente - carrega tudo para agrupar
  def orders_by_city
    @city_counts = Order.count_orders_by_city
  end
end
