from pipeline_dimensional_data.flow import DimensionalDataFlow
import utils

def run(start_date, end_date):
    pipeline = DimensionalDataFlow()

    result = pipeline.exec(start_date, end_date)

    if result['success']:
        print("Pipeline completed successfully!")
    else:
        print(f"Pipeline execution failed: {result['error']}")

if __name__ == "__main__":
    utils.test_connection()
    run(start_date = '2024-01-01', end_date = '2024-12-31')
