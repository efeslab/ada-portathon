#ifndef _LIBLINEAR_H
#define _LIBLINEAR_H

#ifdef __cplusplus
extern "C" {
#endif

struct feature_node
{
	int index;
	double value;
};

struct problem
{
	int l, n;
	double *y;
	struct feature_node **x;
	double bias;            /* < 0 if no bias term */  
};

enum { L2R_LR, L2R_L2LOSS_SVC_DUAL, L2R_L2LOSS_SVC, L2R_L1LOSS_SVC_DUAL, MCSVM_CS, L1R_L2LOSS_SVC, L1R_LR, L2R_LR_DUAL, L2R_L2LOSS_SVR = 11, L2R_L2LOSS_SVR_DUAL, L2R_L1LOSS_SVR_DUAL }; /* solver_type */

struct parameter
{
	int solver_type;

	/* these are for training only */
	double eps;	        /* stopping criteria */
	double C;
	int nr_weight;
	int *weight_label;
	double* weight;
	double p;
};

struct model
{
	struct parameter param;
	int nr_class;		/* number of classes */
	int nr_feature;
	double *w;
	int *label;		/* label of each class */
	double bias;
};

typedef struct tagl2r_lr_fun l2r_lr_fun;
struct tagl2r_lr_fun
{
	void (*constructor)(struct tagl2r_lr_fun *this, const struct problem *prob, double *C);//constructor pointer
	void (*destructor)(struct tagl2r_lr_fun *this);//destructor pointer

	double (*fun)(struct tagl2r_lr_fun *this, double *w);
	void (*grad)(struct tagl2r_lr_fun *this, double *w, double *g);
	void (*Hv)(struct tagl2r_lr_fun *this, double *s, double *Hs);
	int (*get_nr_variable)(struct tagl2r_lr_fun *this);

	//originally private:
	void (*Xv)(struct tagl2r_lr_fun *this, double *v, double *Xv);
	void (*XTv)(struct tagl2r_lr_fun *this, double *v, double *XTv);

	double *C;
	double *z;
	double *D;
	const struct problem *prob;
};

typedef struct tagl2r_l2_svc_fun l2r_l2_svc_fun;
struct tagl2r_l2_svc_fun
{
	void (*constructor)(struct tagl2r_l2_svc_fun *this, const struct problem *prob, double *C);//constructor pointer
	void (*destructor)(struct tagl2r_l2_svc_fun *this);//destructor pointer

	double (*fun)(struct tagl2r_l2_svc_fun *this, double *w);
	void (*grad)(struct tagl2r_l2_svc_fun *this, double *w, double *g);
	void (*Hv)(struct tagl2r_l2_svc_fun *this, double *s, double *Hs);
	int (*get_nr_variable)(struct tagl2r_l2_svc_fun *this);

	//originally private:
	void (*Xv)(struct tagl2r_l2_svc_fun *this, double *v, double *Xv);
	void (*subXv)(struct tagl2r_l2_svc_fun *this, double *v, double *Xv);
	void (*subXTv)(struct tagl2r_l2_svc_fun *this, double *v, double *XTv);

	double *C;
	double *z;
	double *D;
	int *I;
	int sizeI;
	const struct problem *prob;
};

typedef struct tagl2r_l2_svr_fun l2r_l2_svr_fun;
struct tagl2r_l2_svr_fun
{
	void (*constructor)(struct tagl2r_l2_svr_fun *this, const struct problem *prob, double *C, double p);//constructor pointer
//	void (*destructor)(struct tagl2r_l2_svc_fun *this);//destructor pointer

	double (*fun)(struct tagl2r_l2_svr_fun *this, double *w);
	void (*grad)(struct tagl2r_l2_svr_fun *this, double *w, double *g);
	double p;

	//from inheritance
	void (*Hv)(struct tagl2r_l2_svr_fun *this, double *s, double *Hs);
	int (*get_nr_variable)(struct tagl2r_l2_svr_fun *this);
	void (*Xv)(struct tagl2r_l2_svr_fun *this, double *v, double *Xv);
	void (*subXv)(struct tagl2r_l2_svr_fun *this, double *v, double *Xv);
	void (*subXTv)(struct tagl2r_l2_svr_fun *this, double *v, double *XTv);

	double *C;
	double *z;
	double *D;
	int *I;
	int sizeI;
	const struct problem *prob;
};

typedef struct tagSolver_MCSVM_CS Solver_MCSVM_CS;
struct tagSolver_MCSVM_CS
{
	void (*constructor)(struct tagSolver_MCSVM_CS *this, const struct problem *prob, int nr_class, double *weighted_C, double eps, int max_iter);
	//default double eps=0.1, int max_iter=100000
	void (*destructor)(struct tagSolver_MCSVM_CS *this);
	void (*Solve)(struct tagSolver_MCSVM_CS *this, double *w);

	//originally private:
	void (*solve_sub_problem)(struct tagSolver_MCSVM_CS *this, double A_i, int yi, double C_yi, int active_i, double *alpha_new);
	int (*be_shrunk)(struct tagSolver_MCSVM_CS *this, int i, int m, int yi, double alpha_i, double minG);
	// there's no bool type in C (originally bool be_shrunk)
	double *B, *C, *G;
	int w_size, l;
	int nr_class;
	int max_iter;
	double eps;
	const struct problem *prob;
};





struct model* train(const struct problem *prob, const struct parameter *param);
void cross_validation(const struct problem *prob, const struct parameter *param, int nr_fold, double *target);

double predict_values(const struct model *model_, const struct feature_node *x, double* dec_values);
double predict(const struct model *model_, const struct feature_node *x);
double predict_probability(const struct model *model_, const struct feature_node *x, double* prob_estimates);

int save_model(const char *model_file_name, const struct model *model_);
struct model *load_model(const char *model_file_name);

int get_nr_feature(const struct model *model_);
int get_nr_class(const struct model *model_);
void get_labels(const struct model *model_, int* label);

void free_model_content(struct model *model_ptr);
void free_and_destroy_model(struct model **model_ptr_ptr);
void destroy_param(struct parameter *param);

const char *check_parameter(const struct problem *prob, const struct parameter *param);
int check_probability_model(const struct model *model);
void set_print_string_function(void (*print_func) (const char*));

#ifdef __cplusplus
}
#endif

#endif /* _LIBLINEAR_H */

