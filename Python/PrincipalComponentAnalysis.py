# get working directory 
import os
os.getcwd()
# parse txt file data source
import numpy as np
data = np.genfromtxt('/Data Mining/baseball - Copy.txt', dtype='string', delimiter=None)

import pandas as pd
from pandas import ExcelFile
fil =pd.ExcelFile('/Data Mining/AAERDATAHWPart1.xlsx', sheetname='DATA')
pf =fil.parse('DATA')
pf.isnull().sum()# Provides the total no.of null values in each column
pf.info()#Gives the count of non-null objects
pf.mode() # gives the most occuring values for all columns  of dataframe
half_count = len(pf) / 2
cleandf = pf.dropna(thresh=half_count,axis=1) # Drop any column with more than 50% missing values
cleandf.where(pd.notnull(cleandf), 'Dummy', inplace=True) #Replaces with Dummy value instead of null

selcCols = selcCols.dropna()# drops rows with NA
# counting and selecting data types
cleandf.dtypes.value_counts()
cleandf.select_dtypes(include=['int64','float64']).head()

#Correlation
cleandf.corr()

#Exporting the cleaned data to Excel
cleandf.to_excel('Data Mining/cleanedData.xlsx', sheet_name='sheet1', index=False)
print('{0:.2f}'.format(cleandf['PriceClose'].sum()))

#Histogram to identify outliers
%matplotlib inline
cleandf['PriceClose'].plot(kind='hist',bins=50)

# IQR to identify outlier
p25 = np.percentile(cleandf['Sales'],25)
p75 = np.percentile(cleandf['Sales'],75)
p50 = np.percentile(cleandf['Sales'],50)
IQR = p75 -p25
print(IQR)
print("Lower end",p25-1.5*IQR)
print("Higher end",p75+1.5*IQR)

#Skewness for sales
skewness = (3*(np.mean(cleandf['Sales'])-np.median(cleandf['Sales'])))/np.std(cleandf['Sales'])
print(skewness)

#Skeweness using Z-scores for sales
zscores = (cleandf['Sales']-np.mean(cleandf['Sales']))/np.std(cleandf['Sales'])
Z_skewness = (3*(np.mean(zscores)-np.median(zscores)))/np.std(zscores)

#Normal probability QQ plot
%matplotlib inline
import scipy.stats as stats
import matplotlib.pyplot as plt
stats.probplot(zscores, dist="norm", plot=plt)
plt.title("Normal Q-Q plot")
plt.show()

#Removing Dummy values from Employees
emp = cleandf[cleandf.Employees != 'Dummy'].Employees
#Finding Min and Max values for any column
cleandf.CashShortTermInvestments.idxmin()

# z-score standardization
import numpy as np
from scipy.stats import zscore
from sklearn import preprocessing
numeric_cols = cleandf.select_dtypes(include=['float64','int32']).columns
zout = cleandf[numeric_cols].apply(zscore)

# select first 35 columns

zout = zout.iloc[:,0:34]

#Principal Component Analysis
import numpy as np
from sklearn.decomposition import PCA
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import scale
%matplotlib inline
X=zout.values
X = scale(X)
pca = PCA(n_components=4)
pca.fit(X)
var= pca.explained_variance_ratio_

#Cumulative Variance explains
var1=np.cumsum(np.round(pca.explained_variance_ratio_, decimals=4)*100)
print var
print var1
print(pca.explained_variance_ratio_) 
plt.plot(pca.explained_variance_ratio_) # scree plot

#plt.plot(var1)
components = zout.DataFrame(pca.components_.transpose(),
                          columns=range(4), index=X.columns)
rotated_components = varimax(components).transpose() # rotation not working
# Magic command to install factoranalyzer from Jupyter
!pip install factor_analyzer
#Factor Analysis with rotation
from factor_analyzer import FactorAnalyzer
fa = FactorAnalyzer()

# stacked/overlay histogram
%matplotlib inline
stackedhist = cleandf[['SHROUT','bktype']]
stackedhist.plot(kind='hist', stacked=True, bins=5)

#Scatter plots
%matplotlib inline
import matplotlib.pyplot as plt
colors = ("red","blue")
plt.title('Price & ShareOutstanding scatter plot')
plt.scatter(cleandf['PRC'], cleandf['SHROUT'], c=colors, alpha=0.5)
plt.legend(loc=1)
plt.xlabel("Price");
plt.ylabel("Share Outstanding");
plt.show()

# Writing multiple output to same Excel sheet
writer = pd.ExcelWriter('Data Mining/output.xlsx')
zout.to_excel('Data Mining/standardSEC2.xlsx', sheet_name='sheet1', index=False)
zout.to_excel(writer,'Sheet1')
zout1.to_excel(writer,'Sheet3')
writer.save()
