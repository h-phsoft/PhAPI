const ResultManager = require('../utils/responseManager');
const logger = require('../utils/logger');

class UnifiedReportService {
  constructor(report, dbConn) {
    this.report = report;
    this.dbConn = dbConn;
  }

  async init(vParams) {
    try {
      let params = {};
      if (vParams) {
        try {
          params = typeof vParams === 'string' ? JSON.parse(vParams) : vParams;
        } catch (e) {
          params = {data: vParams};
        }
      }

      const metadata = {
        name: this.report.getName(),
        title: this.report.getTitle(),
        description: this.report.getDescription(),
        fields: this.report.getFields().map(f => ({
            name: f.name || f,
            label: f.label || f,
            type: f.type || 'string'
          })),
        parameters: this.report.getParameters().map(p => ({
            name: p.name,
            label: p.label || p.name,
            type: p.type || 'text',
            required: p.required || false,
            defaultValue: p.defaultValue || null,
            options: p.options || null
          })),
        chartConfig: this.report.getChartConfig(),
        isDashboard: this.report.isDashboard()
      };

      return ResultManager.ok(metadata);
    } catch (error) {
      logger.error('UnifiedReportService.init error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async statistics(vParams) {
    try {
      let params = {};
      if (vParams) {
        try {
          params = typeof vParams === 'string' ? JSON.parse(vParams) : vParams;
        } catch (e) {
          params = {data: vParams};
        }
      }

      const query = this.report.getQuery();
      const [rows] = await this.dbConn.query(query, params);

      // Calculate statistics
      const stats = {
        total: rows.length,
        summary: {
          count: rows.length,
          fields: Object.keys(rows[0] || {}).length,
          data: rows
        },
        aggregations: this.calculateAggregations(rows)
      };

      return ResultManager.ok(stats);
    } catch (error) {
      logger.error('UnifiedReportService.statistics error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async query(vParams) {
    try {
      let params = {};
      if (vParams) {
        try {
          params = typeof vParams === 'string' ? JSON.parse(vParams) : vParams;
        } catch (e) {
          params = {data: vParams};
        }
      }

      const query = this.report.getQuery();
      const [rows] = await this.dbConn.query(query, params);

      return ResultManager.ok({
        data: rows,
        count: rows.length,
        query: query,
        parameters: params
      });
    } catch (error) {
      logger.error('UnifiedReportService.query error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async queryPDF(userId, vParams) {
    try {
      const result = await this.query(vParams);
      if (!result.success) {
        return result;
      }

      // In a real implementation, you would generate PDF here
      // For now, return the data with PDF metadata
      return ResultManager.ok({
        data: result.data,
        format: 'PDF',
        generated: new Date().toISOString(),
        userId: userId,
        reportName: this.report.getName(),
        // PDF generation would go here
        pdfUrl: `/reports/${this.report.getName()}_${Date.now()}.pdf`
      });
    } catch (error) {
      logger.error('UnifiedReportService.queryPDF error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async dashLine(vParams) {
    try {
      let params = {};
      if (vParams) {
        try {
          params = typeof vParams === 'string' ? JSON.parse(vParams) : vParams;
        } catch (e) {
          params = {data: vParams};
        }
      }

      const query = this.report.getQuery();
      const [rows] = await this.dbConn.query(query, params);

      // Auto-detect chart data
      const labels = rows.map(row => row.label || row.name || row.date || Object.values(row)[0]);
      const values = rows.map(row => row.value || row.count || Object.values(row)[1]);

      const chartData = {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
              label: this.report.getTitle() || 'Line Chart',
              data: values,
              borderColor: '#3B82F6',
              backgroundColor: 'rgba(59, 130, 246, 0.1)',
              fill: true
            }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top'
            },
            title: {
              display: true,
              text: this.report.getTitle() || 'Line Chart'
            }
          }
        }
      };

      return ResultManager.ok(chartData);
    } catch (error) {
      logger.error('UnifiedReportService.dashLine error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async dashPie(vParams) {
    try {
      let params = {};
      if (vParams) {
        try {
          params = typeof vParams === 'string' ? JSON.parse(vParams) : vParams;
        } catch (e) {
          params = {data: vParams};
        }
      }

      const query = this.report.getQuery();
      const [rows] = await this.dbConn.query(query, params);

      // Auto-detect chart data
      const labels = rows.map(row => row.label || row.name || Object.values(row)[0]);
      const values = rows.map(row => row.value || row.count || Object.values(row)[1]);

      const chartData = {
        type: 'pie',
        data: {
          labels: labels,
          datasets: [{
              data: values,
              backgroundColor: [
                '#EF4444', '#3B82F6', '#10B981', '#F59E0B',
                '#8B5CF6', '#EC4899', '#14B8A6', '#F97316'
              ]
            }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top'
            },
            title: {
              display: true,
              text: this.report.getTitle() || 'Pie Chart'
            }
          }
        }
      };

      return ResultManager.ok(chartData);
    } catch (error) {
      logger.error('UnifiedReportService.dashPie error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  // Helper method to calculate aggregations
  calculateAggregations(rows) {
    if (!rows || rows.length === 0) {
      return {};
    }

    const aggregations = {};
    const firstRow = rows[0];

    for (const key of Object.keys(firstRow)) {
      const values = rows.map(row => row[key]).filter(v => v !== null && v !== undefined);
      if (values.length === 0)
        continue;

      const numericValues = values.filter(v => !isNaN(parseFloat(v)));
      if (numericValues.length > 0) {
        const sum = numericValues.reduce((a, b) => a + parseFloat(b), 0);
        aggregations[`${key}_sum`] = sum;
        aggregations[`${key}_avg`] = sum / numericValues.length;
        aggregations[`${key}_count`] = numericValues.length;
        aggregations[`${key}_min`] = Math.min(...numericValues);
        aggregations[`${key}_max`] = Math.max(...numericValues);
      }
    }

    return aggregations;
  }
}

module.exports = UnifiedReportService;