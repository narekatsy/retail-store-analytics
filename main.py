from pipeline_dimensional_data.flow import DimensionalDataFlow

if __name__ == "__main__":
    pipeline = DimensionalDataFlow()
    result = pipeline.exec()
    if not result["success"]:
        print(f"Pipeline execution failed: {result['error']}")
    else:
        print("Pipeline completed successfully!")
